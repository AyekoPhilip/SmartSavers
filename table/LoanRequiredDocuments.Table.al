table 50389 "Loan Required Documents"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Editable = false;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Product Class"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Savings,Loans';
            OptionMembers = " ","Savings","Loans";
            Caption = 'Product Class';
            DataClassification = CustomerContent;
        }
        field(50011; "Document No."; Code[10])
        {
            Editable = false;
            TableRelation = "Application Document Setup" WHERE("Document Type" = CONST(Loan));
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ApplicationDocumentSetup: Record "Application Document Setup";
            begin
            end;
        }
        field(50012; "Description"; Text[250])
        {
            Editable = false;
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50013; "Single Party/Multiple"; Option)
        {
            Editable = false;
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = "Single","Multiple","Business";
            Caption = 'Single Party/Multiple';
            DataClassification = CustomerContent;
        }
        field(50014; "Product ID"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Product ID';
            DataClassification = CustomerContent;
        }
        field(50015; "Product Name"; Text[100])
        {
            Editable = false;
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50016; "Loan No."; Code[50])
        {
            Editable = false;
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50017; "Provided"; Option)
        {
            OptionCaption = ' ,No,Yes,Waived';
            OptionMembers = " ","No","Yes","Waived";
            Caption = 'Provided';
            DataClassification = CustomerContent;
        }
        field(50018; "License Expiry Date"; Date)
        {
            Caption = 'License Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50019; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = ' ,Payslip,Application Form,Bank Statement,ID Copy,KRA PIN Certificate,Others';
            OptionMembers = " ","Payslip","Application Form","Bank Statement","ID Copy","KRA PIN Certificate","Others";
            Caption = 'Document Type';
        }
        field(50020; "Document Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Path';
        }
    }

    keys
    {
        key("Key1"; "Loan No.", "Entry No.")
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
        Text001: Label 'This loan cannot be modified since it is %1';
}




