table 50503 "Loan Mandatory Requirements"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Mandatory Requirement"; Option)
        {
            OptionCaption = ' ,Salary,Business Income,Member Deposits,Collateral or Guarantors';
            OptionMembers = " ","Salary","Business Income","Member Deposits","Collateral or Guarantors";
            Caption = 'Mandatory Requirement';
            DataClassification = CustomerContent;
        }
        field(50012; "Provided ?"; Boolean)
        {
            Caption = 'Provided ?';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    trigger OnInsert()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    var
        LoanApp: Record Loans;
        Text001: Label 'The loan is already %1 and cannot modify';
}




