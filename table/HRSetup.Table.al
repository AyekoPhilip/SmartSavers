using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Journal;
table 50065 "HR Setup"
{
    Caption = 'HR Setup';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(50009; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(50010; "Employee Nos."; Code[10])
        {
            Caption = 'Employee Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50011; "Training Application Nos."; Code[10])
        {
            Caption = 'Training Application Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50012; "Leave Application Nos."; Code[10])
        {
            Caption = 'Leave Application Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50013; "Disciplinary Cases Nos."; Code[10])
        {
            Caption = 'Disciplinary Cases Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50014; "Base Calender"; Code[10])
        {
            Caption = 'Base Calender';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50015; "Transaction Req Nos."; Code[10])
        {
            Caption = 'Transaction Req Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50016; "Employee Requisition Nos."; Code[10])
        {
            Caption = 'Employee Requisition Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50017; "Job Application Nos."; Code[10])
        {
            Caption = 'Job Application Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50018; "Exit Interview Nos."; Code[10])
        {
            Caption = 'Exit Interview Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50019; "Appraisal Nos."; Code[10])
        {
            Caption = 'Appraisal Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50020; "Company Activities"; Code[10])
        {
            Caption = 'Company Activities';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50021; "Default Leave Post Template"; Code[10])
        {
            Caption = 'Default Leave Post Template';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50022; "Positive Leave Post Template"; Code[10])
        {
            Caption = 'Positive Leave Post Template';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50023; "Leave Template"; Code[10])
        {
            Caption = 'Leave Template';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50024; "Leave Batch"; Code[10])
        {
            Caption = 'Leave Batch';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50025; "Job Interview Nos."; Code[10])
        {
            Caption = 'Job Interview Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50026; "Company Documents"; Code[10])
        {
            Caption = 'Company Documents';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50027; "Hr Policies"; Code[10])
        {
            Caption = 'Hr Policies';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50028; "Notice Board Nos."; Code[10])
        {
            Caption = 'Notice Board Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50029; "Leave Reimbursement Nos."; Code[10])
        {
            Caption = 'Leave Reimbursement Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50030; "Min. Leave App. Months"; Integer)
        {
            Caption = 'Min. Leave App. Months';
            DataClassification = CustomerContent;
        }
        field(50031; "Negative Leave Post Batch"; Code[10])
        {
            Caption = 'Negative Leave Post Batch';
            DataClassification = CustomerContent;
        }
        field(50032; "Appraisal Method"; Code[10])
        {
            Caption = 'Appraisal Method';
            DataClassification = CustomerContent;
        }
        field(50033; "Appraisal Template"; Code[10])
        {
            Caption = 'Appraisal Template';
            DataClassification = CustomerContent;
        }
        field(50034; "Appraisal Batch"; Code[10])
        {
            Caption = 'Appraisal Batch';
            DataClassification = CustomerContent;
        }
        field(50035; "Appraisal Post Period (Period)"; Date)
        {
            Caption = 'Appraisal Post Period (Period)';
            DataClassification = CustomerContent;
        }
        field(50036; "Appraisal Post Period (To)"; Date)
        {
            Caption = 'Appraisal Post Period (To)';
            DataClassification = CustomerContent;
        }
        field(50037; "Target Setting Month"; Code[10])
        {
            Caption = 'Target Setting Month';
            DataClassification = CustomerContent;
        }
        field(50038; "Appraisal Interval"; Code[10])
        {
            Caption = 'Appraisal Interval';
            DataClassification = CustomerContent;
        }
        field(50039; "Job ID Nos."; Code[10])
        {
            Caption = 'Job ID Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50040; "Hr Loan Nos."; Code[10])
        {
            Caption = 'Hr Loan Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50041; "Loan Batch Nos."; Code[10])
        {
            Caption = 'Loan Batch Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50042; "Overtime Req Nos."; Code[10])
        {
            Caption = 'Overtime Req Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50043; "Overtime Payroll Code"; Code[10])
        {
            Caption = 'Overtime Payroll Code';
            DataClassification = CustomerContent;
        }
        field(50044; "Interns Req. Nos"; Code[10])
        {
            Caption = 'Interns Req. Nos';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50045; "Loan Application Nos."; Code[10])
        {
            Caption = 'Loan Application Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50046; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            TableRelation = "Pr Employee Posting Group";
            DataClassification = CustomerContent;
        }
        field(50047; "NetPay Post Options"; Enum "Gen. Journal Account Type")
        {
            DataClassification = CustomerContent;
        }
        field(40; "Payroll Req Nos"; Code[20])
        {
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
            Caption = 'Payroll Req Nos';
        }
    
        field(50048; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50049; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting), Blocked = const(false))
            else if ("Account Type" = CONST(Customer)) Customer
            else if ("Account Type" = CONST(Vendor)) Vendor
            else if ("Account Type" = CONST("Bank Account")) "Bank Account";
        }
    }
    keys
    {
        key("PK"; "Primary Key")
        {
            Clustered = true;
        }
    }
}
