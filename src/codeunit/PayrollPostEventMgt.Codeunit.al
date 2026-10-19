codeunit 50009 "Payroll Post Event Mgt"
{

    trigger OnRun()
    begin
        UpdateObjEmpDetail();
    end;

    procedure UpdateObjEmpDetail()
    var
        EmployeeMgt: Record Employee;
        ObjtEmp: Record "Hr Employees";
        ObjtEmp2: Record "Hr Employees";
        DocMgt: Codeunit "Doc. Mngt";
        StrnlEmpCode: Code[100];
        ProgressWindow: Dialog;
        PayrollDialog: Label 'Updating Employee No. #1#######';
    begin
        emplPostgroup.Get('PAYROLL');

        EmployeeMgt.SetRange(Status, EmployeeMgt.Status::Active);
        EmployeeMgt.SetFilter("Date Of Join", '<>%1', 0D);
        if EmployeeMgt.FindSet() then begin
            ProgressWindow.Open(PayrollDialog);
            repeat
                Sleep(100);

                ObjtEmp.Reset();
                ObjtEmp.SetRange("No.", EmployeeMgt."No.");
                if ObjtEmp.FindFirst() then begin

                    if ObjtEmp."Date Of Birth" <> EmployeeMgt."Birth Date" then
                        ObjtEmp.Validate("Date Of Birth", EmployeeMgt."Birth Date");
                    if ObjtEmp."Date of Join" <> EmployeeMgt."Date Of Join" then
                        ObjtEmp.Validate("Date of Join", EmployeeMgt."Date Of Join");
                    if ObjtEmp.Status <> EmployeeMgt.Status then
                        ObjtEmp.Validate(Status, EmployeeMgt.Status);
                    if ObjtEmp."Department Code" <> EmployeeMgt."Responsibility Center" then
                        ObjtEmp."Department Code" := EmployeeMgt."Responsibility Center";
                    if ObjtEmp."Responsibility Centre" <> EmployeeMgt."Responsibility Center" then
                        ObjtEmp."Responsibility Centre" := EmployeeMgt."Responsibility Center";
                    if ObjtEmp."Member No." <> EmployeeMgt."BOSA Member No." then
                        ObjtEmp."Member No." := EmployeeMgt."BOSA Member No.";
                    if ObjtEmp."Global Dimension 1 Code" <> EmployeeMgt."Global Dimension 1 Code" then
                        ObjtEmp."Global Dimension 1 Code" := EmployeeMgt."Global Dimension 1 Code";
                    ObjtEmp."Approval Status" := ObjtEmp."Approval Status"::Approved;
                    if ObjtEmp."Salary Grade" <> EmployeeMgt."Salary Scale" then
                        ObjtEmp."Salary Grade" := EmployeeMgt."Salary Scale";
                    if ObjtEmp."Salary Notch/Step" <> EmployeeMgt."Present Pointer" then
                        ObjtEmp."Salary Notch/Step" := EmployeeMgt."Present Pointer";
                    if ObjtEmp."Posting Group" = '' then
                        ObjtEmp."Posting Group" := emplPostgroup.Code;
                    ObjtEmp.Modify(true);
                    updateStaffselfInitiatedDoc(ObjtEmp."No.");
                end else begin

                    ObjtEmp2.Init();
                    InitCustEmpEntry(EmployeeMgt, ObjtEmp2);
                    ObjtEmp2.Insert(true);
                    updateStaffselfInitiatedDoc(ObjtEmp2."No.");
                end;
                ProgressWindow.Update(1, EmployeeMgt."No." + '::' + EmployeeMgt."First Name");
            until EmployeeMgt.Next() = 0;
            ProgressWindow.Close();
        end;
    end;

    procedure InitCustEmpEntry(VarVariant: Record Employee; var EmployeeEntry: Record "Hr Employees")
    begin
        EmployeeEntry.CopyFromHrEmployee(VarVariant);
    end;

    local procedure updateStaffselfInitiatedDoc(StrnEmp: Code[100])
    begin

        HrPayrollRequest.Reset();
        HrPayrollRequest.SetRange("Employee No.", StrnEmp);
        HrPayrollRequest.SetRange(Status, HrPayrollRequest.Status::Posted);
        HrPayrollRequest.SetRange("Approval Status", HrPayrollRequest."Approval Status"::Open);
        if HrPayrollRequest.FindFirst() then begin
            repeat

                if HrPayrollRequest.Type = HrPayrollRequest.Type::Earning then begin
                    prTranscode.Reset();
                    prTranscode.SetRange(Code, HrPayrollRequest.Code);
                    prTranscode.SetRange("Transaction Type", prTranscode."Transaction Type"::Income);
                    if prTranscode.FindFirst() then begin

                        prEmployeeTrans.Reset();
                        prEmployeeTrans.SetRange("Employee Code", StrnEmp);
                        prEmployeeTrans.SetRange("Transaction Code", prTranscode.Code);
                        if prEmployeeTrans.FindFirst() then begin
                            prEmployeeTrans.Validate(Amount, HrPayrollRequest.Amount);
                            prEmployeeTrans.Modify(true)
                        end else begin

                            prEmployeeTransact.Init();
                            prEmployeeTransact."Employee Code" := StrnEmp;
                            prEmployeeTransact.Validate("Transaction Code", HrPayrollRequest.Code);
                            prEmployeeTransact.Validate(Amount, HrPayrollRequest.Amount);
                            prEmployeeTransact.Insert(true)
                        end;
                    end
                end else begin

                    prTranscode.Reset();
                    prTranscode.SetRange(Code, HrPayrollRequest.Code);
                    prTranscode.SetRange("Transaction Type", prTranscode."Transaction Type"::Deduction);
                    if prTranscode.FindFirst() then begin

                        prEmployeeTrans.Reset();
                        prEmployeeTrans.SetRange("Employee Code", StrnEmp);
                        prEmployeeTrans.SetRange("Transaction Code", prTranscode.Code);
                        if prEmployeeTrans.FindFirst() then begin
                            prEmployeeTrans.Validate(Amount, HrPayrollRequest.Amount);
                            prEmployeeTrans.Modify(true)
                        end else begin

                            prEmployeeTransact.Init();
                            prEmployeeTransact."Employee Code" := StrnEmp;
                            prEmployeeTransact.Validate("Transaction Code", HrPayrollRequest.Code);
                            prEmployeeTransact.Validate(Amount, HrPayrollRequest.Amount);
                            prEmployeeTransact.Insert(true)
                        end;
                    end
                end;
            until HrPayrollRequest.Next() = 0;
        end;
    end;

    var

        prsalaryInfo: Record "Pr Salary Card";
        prsalaryCard: Record "Pr Salary Card";
        prEmployeeTrans: Record "Pr Employee Transaction";
        prEmployeeTransact: Record "Pr Employee Transaction";
        objtEmp: Record "Hr Employees";
        emplPostgroup: Record "Pr Employee Posting Group";
        prTranscode: Record "Pr Transaction Code";
        HrPayrollRequest: Record "Payroll Requests";

}
