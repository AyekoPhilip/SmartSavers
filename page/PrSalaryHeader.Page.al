page 50109 "Pr Salary Header"
{
    ApplicationArea = All;
    Caption = 'Salary Header';
    PageType = Card;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "HR Employees";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Join"; Rec."Date of Join")
                {
                    ToolTip = 'Specifies the value of the Date of Join field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ToolTip = 'Specifies the value of the Payment Mode field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Full/Part Time"; Rec."Full/Part Time")
                {
                    ToolTip = 'Specifies the value of the Full/Part Time field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the Grade field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Disabled; Rec.Disabled)
                {
                    ToolTip = 'Specifies the value of the Disabled field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
            }
            part(SalaryInformation; "Pr Salary Information")
            {
                Caption = 'Salary Information';
                SubPageLink = "Employee Code" = field("No.");
            }
            group("Posting and Statutory Details")
            {
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies the value of the Posting Group field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ToolTip = 'Specifies the value of the Posting Group field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ToolTip = 'Specifies the value of the HIF field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("NSSF No."; Rec."NSSF No.")
                {
                    ToolTip = 'Specifies the value of the SSF field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("HELB No."; Rec."HELB No.")
                {
                    ToolTip = 'Specifies the value of the HELB field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }

            }
            group(Dimensions)
            {
                Editable = false;
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }

            part(Picture; "Hr Employee Picture")
            {
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
            part(EmployeeFactbox; "Employee Factbox")
            {
                Caption = 'Employee Factbox';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessPayroll)
            {
                Image = PostedCreditMemo;
                Caption = 'Process Payroll';
                Visible = true;
                trigger OnAction()
                begin
                    ResponseTxt := 0;
                    ResponseTxt := ConfirmPost();

                    case ResponseTxt of
                        0:
                            begin
                                Error('Invalid Selection');
                            end;
                        1:
                            begin
                                Codeunit.Run(Codeunit::"Payroll Post Mngt.", Rec)
                            end;
                        2:
                            begin

                                objPeriod.Reset();
                                objPeriod.SetRange(Closed, false);
                                if objPeriod.FindFirst() then
                                    SelectedPeriod := objPeriod."Date Opened";

                                HrEmployee.Reset();
                                HrEmployee.SetRange(Status, HrEmployee.Status::Active);
                                HrEmployee.SetRange("Approval Status", HrEmployee."Approval Status"::Approved);
                                if HrEmployee.FindSet() then begin
                                    ProgressWindow.Open(PayrollDialog);
                                    repeat
                                        HrEmployee.TestField("Date of Join");
                                        Sleep(100);

                                        SalCard.Reset();
                                        SalCard.SetRange("Suspend Pay", false);
                                        SalCard.SetRange("Employee Code", HrEmployee."No.");
                                        if SalCard.FindFirst() then begin

                                            PayrollPostMgt.fnProcesspayroll(HrEmployee."No.", HrEmployee."Date Of Join",
                                            SalCard."Basic Pay", SalCard."Pays PAYE", SalCard."Pays NSSF",
                                            SalCard."Pays NHIF", SelectedPeriod, SelectedPeriod, '', '',
                                            HrEmployee."Date Of Leaving", true, HrEmployee."Department Code", '',
                                            HrEmployee."Global Dimension 1 Code", HrEmployee."Global Dimension 2 Code", false);

                                        end;
                                        ProgressWindow.Update(1, HrEmployee."No." + '::' + HrEmployee.Name);
                                    until HrEmployee.Next() = 0
                                end;
                                ProgressWindow.Close();

                                Commit();
                                PrsalCard.Reset();
                                PrsalCard.SetRange("Employee Code", Rec."No.");
                                PrsalCard.SetRange("Period Filter", SelectedPeriod);
                                if PrsalCard.FindFirst() then begin
                                    Report.Run(Report::"Pr Individual Payslip", true, false, PrsalCard);
                                end;
                            end;
                    end;

                end;
            }
        }
        area(Reporting)
        {
            action(ViewPayslip)
            {
                Image = SocialSecurity;
                Caption = 'View Payslip';
                trigger OnAction()
                begin

                    objPeriod.Reset();
                    objPeriod.SetRange(Closed, false);
                    if objPeriod.FindFirst() then
                        SelectedPeriod := objPeriod."Date Opened";
                    PayrollPostMgt.fnJournalPreviewMngt(Enum::CustomApprovalEntriesDocType::Salary,
                    Rec."No.", '', '', SelectedPeriod, Enum::BCObjectTypes::Report);
                end;
            }
        }
        area(Navigation)
        {
            action(EmployeeTransactions)
            {
                Image = Allocate;
                Caption = 'Employee Transactions';
                RunObject = page "Pr Employee transaction";
                RunPageLink = "Employee Code" = field("No.");
                trigger OnAction()
                begin
                    ///dfghjkl
                end;
            }
             action("Monthly Contribution")
            {
                Image = Category;
                Caption='Sacco Deductions';
                RunObject = Page "Member Contribution";
                RunPageLink = "Account No." = field("Member No.");
                ApplicationArea = All;
            }
            
            action(AssignEarnings)
            {
                Image = ElectronicDoc;
                Caption = 'Earnings';
                RunObject = page "Pr List Transaction";
                RunPageLink = "Employee Code" = field("No.");
                RunPageView = where("Transaction Type" = filter(Income));
                trigger OnAction()
                begin
                    ///dfghjkl

                end;
            }
            action(AssignDeductions)
            {
                Image = SocialSecurity;
                Caption = 'Deductions';
                RunObject = page "Pr List Transaction";
                RunPageLink = "Employee Code" = field("No.");
                RunPageView = where("Transaction Type" = filter(Deduction));
                trigger OnAction()
                begin
                    ///dfghjkl

                end;
            }
            action(AssignArrears)
            {
                Image = AssemblyOrder;
                Caption = 'Salary Arrears';
                RunObject = page "Pr Salary Arrears";
                RunPageLink = "Employee Code" = field("No.");
                trigger OnAction()
                begin

                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(ProcessPayroll_Promoted; ProcessPayroll)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(ViewPayslip_Promoted; ViewPayslip)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Transaction', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(EmployeeTransactions_Promoted; EmployeeTransactions)
                {
                }
                actionref("Monthly Contribution_Promoted"; "Monthly Contribution")
                {
                }
                actionref(AssignArrears_Promoted; AssignArrears)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(AssignEarnings_Promoted; AssignEarnings)
                {
                }
                actionref(AssignDeductions_Promoted; AssignDeductions)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Associated Accounts', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Process Current,&Process Payroll';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 2 then
            DefaultOption := 2;
        if DefaultOption <= 0 then
            DefaultOption := 0;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to Post');
        PassInt := Selection;

        if Selection = 0 then
            exit;
        exit(PassInt);
    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField("Approval Status", Rec."Approval Status"::Open);

    end;

    trigger OnAfterGetRecord()
    begin


    end;

    trigger OnClosePage()
    begin


    end;

    var
        objPeriod: Record "Pr Payroll Period";
        SelectedPeriod: Date;
        HrEmployee: Record "HR Employees";
        ResponseTxt: Integer;
        PayrollPostMgt: Codeunit "Payroll Post Mngt.";
        SalCard: Record "Pr Salary Card";
        ProgressWindow: Dialog;
        PrsalCard: Record "Pr Salary Card";
        PayrollDialog: Label 'Processing Salary for Employee No. #1#######';
        OnCompleteDialogTxt: Label 'Payroll processing completed successfully.';
}
