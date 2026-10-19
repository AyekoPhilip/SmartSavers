pageextension 51122 "EmployeeCardPageExt" extends "Employee Card"
{

    layout
    {
        modify("Employment Date")
        {
            Visible = false;
        }
        modify("Birth Date")
        {
            ShowMandatory = true;
        }
        modify("Job Title")
        {
            Visible = false;
        }
        modify("Bank Branch No.")
        {
            Visible = false;
        }
        modify("Bank Account No.")
        {
            Visible = false;
        }
        modify("Employee Posting Group")
        {
            Visible = false;
        }
        modify("Application Method")
        {
            Visible = false;
        }
        modify(IBAN)
        {
            Visible = false;
        }
        modify("SWIFT Code")
        {
            Visible = false;
        }
        modify("Emplymt. Contract Code")
        {
            Visible = false;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Cause of Inactivity Code")
        {
            Editable = Rec.Status = Rec.Status::Inactive;

            trigger OnAfterValidate()
            var
                InactivityRec: Record "Cause of Inactivity";
            begin
                if InactivityRec.Get(Rec."Cause of Inactivity Code") then
                    InactiveDescription := InactivityRec.Description;
            end;
        }
        addafter("Last Name")
        {
            field("Other Name"; Rec."Other Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Other Name field.';
            }
        }
        addafter("Cause of Inactivity Code")
        {
            field(InactiveDescription; InactiveDescription)
            {
                ApplicationArea = All;
                Caption = 'Cause of Inactivity Description';
                Editable = false;
            }
        }

        addafter("Privacy Blocked")
        {
            field("User ID"; Rec."User ID")
            {
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the User ID field';
                ApplicationArea = All;
            }
            field("Manager/Supervisor"; Rec."Manager/Supervisor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Manager/Supervisor field.';
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field';
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field';
                ApplicationArea = All;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Responsibility Center field.';
            }
        }

        addlast(Personal)
        {
            field(Disabled; Rec.Disabled)
            {
                ToolTip = 'Specifies the value of the Disabled field';
                ApplicationArea = All;

                trigger OnValidate()
                begin

                    if Rec.Disabled = Rec.Disabled::No then begin
                        DisabilityView := false;
                    end else
                        DisabilityView := true;
                end;
            }
            group(Control197)
            {
                ShowCaption = false;
                Visible = DisabilityView;

                field(Disability; Rec.Disability)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Disability field';
                    ApplicationArea = All;
                }
                field("Disability Certificate"; Rec."Disability Certificate")
                {
                    Caption = 'Disability Certificate No.';
                    ToolTip = 'Specifies the value of the Disability Certificate No. field';
                    ApplicationArea = All;
                }
            }
            field("Date of Birth"; Rec."Birth Date")
            {
                ApplicationArea = BasicHR;
                Caption = 'Date of Birth';
                Importance = Standard;
                ToolTip = 'Specifies the employee''s date of birth.';
                Visible = false;
            }
            field("Date of Birth - Age"; Rec."Date of Birth - Age")
            {
                Caption = ' Age';
                Importance = Standard;
                ToolTip = 'Specifies the value of the  Age field';
                ApplicationArea = All;
            }
            field("ID No."; Rec."ID No.")
            {
                ToolTip = 'Specifies the value of the ID No. field';
                ApplicationArea = All;
            }
            field("Marital Status"; Rec."Marital Status")
            {
                ToolTip = 'Specifies the value of the Marital Status field';
                ApplicationArea = All;
            }
            field(Religion; Rec.Religion)
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Religion field';
                ApplicationArea = All;
            }
            field("Ethnic Origin"; Rec."Ethnic Origin")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Ethnic Origin field';
                ApplicationArea = All;
            }
            field("Ethnic Community"; Rec."Ethnic Community")
            {
                Caption = 'Ethnic Code';
                Visible = false;
                ToolTip = 'Specifies the value of the Ethnic Code field';
                ApplicationArea = All;
            }
            field("Ethnic Name"; Rec."Ethnic Name")
            {
                Caption = 'Ethnic Community';
                Visible = false;
                ToolTip = 'Specifies the value of the Ethnic Community field';
                ApplicationArea = All;
            }
            field("Home District"; Rec."Home District")
            {
                ToolTip = 'Specifies the value of the Home District field';
                ApplicationArea = All;
            }
            field("First Language"; Rec."First Language")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the First Language field';
                ApplicationArea = All;
            }
            field("Second Language"; Rec."Second Language")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Second Language field';
                ApplicationArea = All;
            }
            field("Other Language"; Rec."Other Language")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Other Language field';
                ApplicationArea = All;
            }
        }
        addafter("Address & Contact")
        {
            group("Employment Information")
            {
                Caption = 'Employment Information';

                field("Job Position"; Rec."Job Position")
                {
                    Caption = 'Job Position';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Position field';
                }
                field("Job Position Title"; Rec."Job Position Title")
                {
                    Caption = 'Job Title';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Title field';
                }
                field("Secondary Job Position"; Rec."Secondary Job Position")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Secondary Job Position field.';
                }
                field("Secondary Job Position Title"; Rec."Secondary Job Position Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Secondary Job Position Title field.';
                }

                group("Contract Information")
                {
                    Caption = 'Contract Information';
                    Editable = true;
                    field("Contract Type"; Rec."Contract Type")
                    {
                        ToolTip = 'Specifies the value of the Contract Type field';
                        ApplicationArea = All;
                    }
                    field("Contract Number"; Rec."Contract Number")
                    {
                        ToolTip = 'Specifies the value of the Contract Number field';
                        ApplicationArea = All;
                    }
                    field("Contract Length"; Rec."Contract Length")
                    {
                        ToolTip = 'Specifies the value of the Contract Length field';
                        ApplicationArea = All;
                    }
                    field("Contract Start Date"; Rec."Contract Start Date")
                    {
                        ToolTip = 'Specifies the value of the Contract Start Date field';
                        ApplicationArea = All;
                    }
                    field("Contract End Date"; Rec."Contract End Date")
                    {
                        ToolTip = 'Specifies the value of the Contract End Date field';
                        ApplicationArea = All;
                    }
                }
            }
        }
        addafter("Employment Information")
        {
            group("Acting Position")
            {
                Caption = 'Acting Position';
                Editable = false;

                field("Acting No"; Rec."Acting No")
                {
                    ToolTip = 'Specifies the value of the Acting No field';
                    ApplicationArea = All;
                }
                field(Control58; Rec."Acting Position")
                {
                    ToolTip = 'Specifies the value of the Acting Position field';
                    ApplicationArea = All;
                }
                field("Acting Description"; Rec."Acting Description")
                {
                    ToolTip = 'Specifies the value of the Acting Description field';
                    ApplicationArea = All;
                }
                label("Details:")
                {
                    Style = Strong;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Relieved Employee"; Rec."Relieved Employee")
                {
                    ToolTip = 'Specifies the value of the Relieved Employee field';
                    ApplicationArea = All;
                }
                field("Relieved Name"; Rec."Relieved Name")
                {
                    ToolTip = 'Specifies the value of the Relieved Name field';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field';
                    ApplicationArea = All;
                }
                field("Reason for Acting"; Rec."Reason for Acting")
                {
                    ToolTip = 'Specifies the value of the Reason for Acting field';
                    ApplicationArea = All;
                }
            }
        }
        addlast(Payments)
        {
            field("BOSA Member No."; Rec."BOSA Member No.")
            {
                ToolTip = 'Specifies the value of the BOSA Member No. field.';
                ApplicationArea = All;
            }
            field("FOSA Account No."; Rec."FOSA Account No.")
            {
                ToolTip = 'Specifies the value of the FOSA Account No. field.';
                ApplicationArea = All;
            }
            field("PIN Number"; Rec."PIN Number")
            {
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the PIN Number field';
                ApplicationArea = All;
            }
            field("NHIF No."; Rec."NHIF No")
            {
                Caption = 'NHIF No.';
                ToolTip = 'Specifies the value of the NHIF No. field';
                ApplicationArea = All;
            }
            field("NSSF No."; Rec."Social Security No.")
            {
                ToolTip = 'Specifies the value of the Social Security No. field';
                ApplicationArea = All;
            }
            field("Pay Mode"; Rec."Pay Mode")
            {
                ToolTip = 'Specifies the value of the Pay Mode field';
                ApplicationArea = All;
            }
            field("Employee's Bank"; Rec."Employee's Bank")
            {
                Caption = 'Bank';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank field';
            }
            field("Employee Bank Name"; Rec."Employee Bank Name")
            {
                Caption = 'Bank Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Bank Name field';
            }
            field("Bank Branch"; Rec."Bank Branch")
            {
                Caption = 'Branch';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch field';
            }
            field("Employee Branch Name"; Rec."Employee Branch Name")
            {
                Caption = 'Branch Name';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch Name field';
            }
            field("Employee Bank Sort Code"; Rec."Employee Bank Sort Code")
            {
                Caption = 'Sort Code';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sort Code field';
            }
            field("Bank Account Number"; Rec."Bank Account Number")
            {
                Caption = 'Bank Account Number';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Account Number field';
            }
            field("Posting Group"; Rec."Posting Group")
            {
                Caption = 'HR Posting Group';
                ToolTip = 'Specifies the value of the HR Posting Group field';
                ApplicationArea = All;
            }
            field("Gratuity Vendor No."; Rec."Gratuity Vendor No.")
            {
                ToolTip = 'Specifies the value of the Gratuity Vendor No. field. This is used for Employees being paid Gratuity';
                ApplicationArea = All;
            }
            field("Debtor Code"; Rec."Debtor Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Debtor Code field for Payroll Loan purposes';
            }
            field("Employee Type"; Rec."Employee Type")
            {
                ToolTip = 'Specifies the value of the Employee Type field';
                ApplicationArea = All;
            }
            field("Exempt from one third rule"; Rec."Exempt from third rule")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exempt from third rule field.';
            }
            field("Salary Scale"; Rec."Salary Scale")
            {
                ToolTip = 'Specifies the value of the Salary Scale field';
                ApplicationArea = All;
            }
            field(Present; Rec."Present Pointer")
            {
                Caption = 'Present Step';
                ToolTip = 'Specifies the value of the Present Step field';
                ApplicationArea = All;
            }
            field("Previous Salary Scale"; Rec."Previous Salary Scale")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Previous Salary Grade field.';
                //Editable = false;
            }
            field(Previous; Rec.Previous)
            {
                Caption = 'Previous Step';
                ToolTip = 'Specifies the value of the Previous Step field';
                ApplicationArea = All;
                //Editable = false;
            }
            field(Halt; Rec.Halt)
            {
                Caption = 'Halt Step';
                Editable = false;
                ToolTip = 'Specifies the value of the Halt Step field';
                ApplicationArea = All;
            }
            field("Pays tax?"; Rec."Pays tax?")
            {
                ToolTip = 'Specifies the value of the Pays tax? field';
                ApplicationArea = All;
            }
            field("Secondary Employee"; Rec."Secondary Employee")
            {
                ToolTip = 'Specifies the value of the Secondary Employee field';
                ApplicationArea = All;
            }
            field("Insurance Relief"; Rec."Insurance Relief")
            {
                ToolTip = 'Specifies the value of the Insurance Relief field';
                ApplicationArea = All;
            }
            field("Pro-Rata Calculated"; Rec."Pro-Rata Calculated")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Pro-Rata Calculated field';
                ApplicationArea = All;
            }
            field(CurrBasicPay; CurrBasicPay)
            {
                Caption = 'Current Basic Pay';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Current Basic Pay field';
            }
            field("Basic Pay"; Rec."Basic Pay")
            {
                ToolTip = 'Specifies the value of the Basic Pay field';
                ApplicationArea = All;
            }
            field("House Allowance"; Rec."House Allowance")
            {
                ToolTip = 'Specifies the value of the House Allowance field';
                ApplicationArea = All;
            }
            field("Insurance Premium"; Rec."Insurance Premium")
            {
                Editable = false;
                ToolTip = 'Specifies the value of the Insurance Premium field';
                ApplicationArea = All;
            }
            field("Total Allowances"; Rec."Total Allowances")
            {
                ToolTip = 'Specifies the value of the Total Allowances field';
                ApplicationArea = All;
            }
            field("Total Deductions"; Rec."Total Deductions")
            {
                ToolTip = 'Specifies the value of the Total Deductions field';
                ApplicationArea = All;
            }
            field("Taxable Allowance"; Rec."Taxable Allowance")
            {
                ToolTip = 'Specifies the value of the Taxable Allowance field';
                ApplicationArea = All;
            }
            field("Cumm. PAYE"; Rec."Cumm. PAYE")
            {
                ToolTip = 'Specifies the value of the Cumm. PAYE field';
                ApplicationArea = All;
            }

        }
        addafter(Payments)
        {
            group("Important Dates")
            {
                Caption = 'Important Dates';

                field("Date Of Join"; Rec."Date Of Join")
                {
                    ToolTip = 'Specifies the value of the Date Of Join field';
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin

                        //"End Of Probation Date":= CALCDATE(HRSetup."Probation Period","Date Of Join");
                    end;
                }
                field("Employment Date - Age"; Rec."Employment Date - Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employment Date - Age field.';
                    Editable = false;
                }
                field("Probation Period"; ProbationPeriod)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the ProbationPeriod field';
                    ApplicationArea = All;
                }
                field("End Of Probation Date"; Rec."End Of Probation Date")
                {
                    Caption = 'Probation End Date';
                    //Editable = false;
                    ToolTip = 'Specifies the value of the Probation End Date field';
                    ApplicationArea = All;
                }
                field("Pension Scheme Join"; Rec."Pension Scheme Join")
                {
                    ToolTip = 'Specifies the value of the Pension Scheme Join field';
                    ApplicationArea = All;
                }
                field("Medical Scheme Join"; Rec."Medical Scheme Join")
                {
                    ToolTip = 'Specifies the value of the Medical Scheme Join field';
                    ApplicationArea = All;
                }
                field("Retirement Date"; Rec."Retirement Date")
                {
                    //Editable = false;
                    ToolTip = 'Specifies the value of the Retirement Date field';
                    ApplicationArea = All;
                }
            }
        }
        addafter("Important Dates")
        {
        }
        addafter("Important Dates")
        {
            group(Separation)
            {
                Caption = 'Separation';

                field("Notice Period"; Rec."Notice Period")
                {
                    ToolTip = 'Specifies the value of the Notice Period field';
                    ApplicationArea = All;
                }
                field("Send Alert to"; Rec."Send Alert to")
                {
                    ToolTip = 'Specifies the value of the Send Alert to field';
                    ApplicationArea = All;
                }
                field("Served Notice Period"; Rec."Served Notice Period")
                {
                    ToolTip = 'Specifies the value of the Served Notice Period field';
                    ApplicationArea = All;
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                    ToolTip = 'Specifies the value of the Date Of Leaving field';
                    ApplicationArea = All;
                }
                field("Termination Category"; Rec."Termination Category")
                {
                    ToolTip = 'Specifies the value of the Termination Category field';
                    ApplicationArea = All;
                }
                field("Exit Interview Date"; Rec."Exit Interview Date")
                {
                    ToolTip = 'Specifies the value of the Exit Interview Date field';
                    ApplicationArea = All;
                }
                field("Exit Interview Done by"; Rec."Exit Interview Done by")
                {
                    ToolTip = 'Specifies the value of the Exit Interview Done by field';
                    ApplicationArea = All;
                }
                field("Allow Re-Employment In Future"; Rec."Allow Re-Employment In Future")
                {
                    ToolTip = 'Specifies the value of the Allow Re-Employment In Future field';
                    ApplicationArea = All;
                }
            }

            group(Anniversary)
            {
                //Editable = false;
                Caption = 'Anniversary Details';

                field("Incremental Month"; Rec."Incremental Month")
                {
                    ToolTip = 'Specifies the value of the Incremental Month field';
                    ApplicationArea = All;
                }

                field("Last Increment Date"; Rec."Last Increment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Increment Date field.';
                }
                field("Next Increment Date"; Rec."Next Increment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Increment Date field.';
                }
                field("Last Date Increment"; Rec."Last Date Increment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Increment field.';
                    Caption = 'Last Increment Date Details';
                }
                field("Next Date Increment"; Rec."Next Date Increment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Date Increment field.';
                    Caption = 'Next Increment Date Details';
                }
            }
        }
    }

    actions
    {
        modify("&Relatives")
        {
            Visible = false;
        }

        addlast("E&mployee")
        {
            action("Activate Employee")
            {
                ApplicationArea = All;
                Caption = 'Activate Employee';
                Image = Action;
                ToolTip = 'Open the list of relatives that are registered for the employee.';
                Enabled = Rec.Status = Rec.Status::Inactive;
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Active;
                    Rec.Modify();
                end;
            }

            action("Next of Kin")
            {
                ApplicationArea = BasicHR;
                Caption = 'Next of Kin';
                Image = Relatives;
                RunObject = page "Employee Relatives";
                RunPageLink = "Employee No." = field("No.");
                RunPageMode = View;
                ToolTip = 'Open the list of relatives that are registered for the employee.';
            }


            action("Leave Aplications")
            {
                Image = JobResponsibility;
                RunObject = page "Hr Leave Application";
                RunPageLink = "Applicant Staff No." = field("No.");
                ToolTip = 'Executes the Leave Aplications action';
                ApplicationArea = All;
            }

            action(Union)
            {
                Image = Union;
                ToolTip = 'Executes the Union action';
                ApplicationArea = All;
            }

        }
        addlast(Processing)
        {
            group(Assign)
            {



            }

            group(Loans)
            {
                action(PLoans)
                {
                    RunObject = page "Loans List Posted";
                    RunPageLink = "Account No." = field("BOSA Member No.");
                    ToolTip = 'Executes the Deduction Loan action';
                    ApplicationArea = All;
                    Visible = false;
                }
                action("Savings Withdrawals")
                {
                    RunObject = page "Account Credit List";
                    RunPageLink = "No." = field("BOSA Member No.");
                    ToolTip = 'Executes the Savings Withdrawals action';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(DefaultAssignment)
            {

            }
            group(Payslips)
            {


            }
            action("Import Data")
            {
                Image = Import;
                Visible = false;
                ToolTip = 'Executes the Import Data action';
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }

        }
        addfirst(Category_Category6)
        {
            actionref("Import Data_Promoted"; "Import Data")
            {
            }
        }
        addlast(Category_Category6)
        {
            actionref(PLoans_Promoted; PLoans)
            {
            }
            actionref("Savings Withdrawals_Promoted"; "Savings Withdrawals")
            {
            }
        }
        modify(Category_Category4)
        {
            Caption = 'Employee', Comment = 'Generated from the PromotedActionCategories property index 3.';
        }
        modify(Category_Category5)
        {
            Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 4.';
        }
        modify(Category_Category6)
        {
            Caption = 'Payroll', Comment = 'Generated from the PromotedActionCategories property index 5.';
        }
        modify(Category_New)
        {
            Caption = 'New', Comment = 'Generated from the PromotedActionCategories property index 0.';
        }
        modify(Category_Process)
        {
            Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';
        }
        modify(Category_Report)
        {
            Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
        }
    }
    trigger OnDeleteRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
    Error(MsgOnPermissionTxt);
    end;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        Rec."Pays tax?" := true;
    end;

    trigger OnOpenPage()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        SetNoFieldVisible();
        IsCountyVisible := FormatAddress.UseCounty(Rec."Country/Region Code");
        SetContractView();
        DisabilityView := false;
    end;

    trigger OnAfterGetRecord()
    var
        Inactive: Boolean;
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if Rec.Status in [Rec.Status::Inactive, Rec.Status::Terminated] then
            Inactive := true
        else
            Inactive := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Date Of Join" = 0D then
            Message('Date of Join has not been specified');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::Employee, FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

    end;

    var
        Employee: Record Employee;

        LeaveType: Record "Leave Type";
        PayPeriod: Record "Pr Payroll Period";
        FormatAddress: Codeunit "Format Address";
        Payroll: Codeunit "Payroll Post Mngt.";
        ProbationPeriod: DateFormula;
        ContractView: Boolean;
        DisabilityView: Boolean;
        IsCountyVisible: Boolean;
        NoFieldVisible: Boolean;
        Visibility: Boolean;
        Numb: Code[20];
        CurrentMonth: Date;
        CurrBasicPay: Decimal;
        Text0001: Label 'Do you want to send the payslip?';
        InactiveDescription: Text;
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';


    local procedure Disability()
    begin
        if Rec."No." <> '' then begin
            if Rec.Disabled = Rec.Disabled::No then begin
                DisabilityView := false;
            end else
                DisabilityView := true;
        end;
    end;

    local procedure DisabilityField()
    begin
        Rec.Disability := '';
    end;

    local procedure GetCurrentPayPeriod(): Date
    begin

    end;

    local procedure SetContractView()
    begin
        if Rec."No." <> '' then begin
            if Rec."Nature of Employment" <> 'CONTRACT' then begin
                ContractView := false;
            end else
                ContractView := true;
        end;
    end;

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible();
    end;
}