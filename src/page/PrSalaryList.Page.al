page 50110 "Pr Salary List"
{
    ApplicationArea = All;
    Caption = 'Salary List';
    PageType = List;
    CardPageId = "Pr Salary Header";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Editable = false;
    SourceTable = "HR Employees";
    UsageCategory = Lists;
    SourceTableView = where(Status = filter(Active), "Approval Status" = filter(Approved));

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field("Date of Join"; Rec."Date of Join")
                {
                    ToolTip = 'Specifies the value of the Date of Join field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
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
                    Rec.OnBeforeOnValidate(Rec, Rec, false);
                end;
            }
            action("Update Employee")
            {
                Image = SocialSecurity;
                Caption = 'Update Employee';
                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Payroll Post Event Mgt")
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
                Caption = 'Sacco Deductions';
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
            action("Member Register")
            {
                Image = SocialSecurity;
                Caption = 'Member Register';
                RunObject = page "Membership Individual";
                RunPageLink = "No." = field("Member No.");
                trigger OnAction()
                begin
                    ///dfghjkl

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
                actionref("Update Employee_Promoted"; "Update Employee")
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

                actionref("Member Register_Promoted"; "Member Register")
                {
                }
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
