table 50380 "Standing Order Register"
{
    DataClassification = CustomerContent;
    fields
    {

        field(50009; "Entry No."; Integer)
        {

        }
        field(50010; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }
        field(50011; "Date Processed"; Date)
        {
            Caption = 'Date Processed';
            DataClassification = CustomerContent;
        }
        field(50012; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50013; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50014; "Source Account No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "Account Banking";
            Caption = 'Source Account No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Source Account Name"; Text[50])
        {
            Caption = 'Source Account Name';
            DataClassification = CustomerContent;
        }
        field(50016; "Member No"; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No';
            DataClassification = CustomerContent;
        }
        field(50017; "Staff/Payroll No."; Code[20])
        {
            Caption = 'Staff/Payroll No.';
            DataClassification = CustomerContent;
        }
        field(50018; "Allow Partial Deduction"; Boolean)
        {
            Caption = 'Allow Partial Deduction';
            DataClassification = CustomerContent;
        }
        field(50019; "Deduction Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Successfull,Partial Deduction,Failed';
            OptionMembers = " ","Successfull","Partial Deduction","Failed";
            Caption = 'Deduction Status';
            DataClassification = CustomerContent;
        }
        field(50020; "Amount"; Decimal)
        {
            NotBlank = true;
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50021; "Amount Deducted"; Decimal)
        {
            Caption = 'Amount Deducted';
            DataClassification = CustomerContent;
        }
        field(50022; "Effective/Start Date"; Date)
        {
            Caption = 'Effective/Start Date';
            DataClassification = CustomerContent;
        }
        field(50023; "Duration"; DateFormula)
        {
            NotBlank = true;
            Caption = 'Duration';
            DataClassification = CustomerContent;
        }
        field(50024; "Frequency"; DateFormula)
        {
            NotBlank = true;
            Caption = 'Frequency';
            DataClassification = CustomerContent;
        }
        field(50025; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50026; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50027; "EFT"; Boolean)
        {
            Caption = 'EFT';
            DataClassification = CustomerContent;
        }
        field(50028; "Transfered to EFT"; Boolean)
        {
            Caption = 'Transfered to EFT';
            DataClassification = CustomerContent;
        }
        field(50029; "Standing Order No."; Code[20])
        {
            Caption = 'Standing Order No.';
            DataClassification = CustomerContent;
        }
        field(50030; "Destination Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,External,Fixed Asset,IC Partner,Internal,Credit';
            OptionMembers = "G/L Account","Customer","Vendor","External","Fixed Asset","IC Partner","Internal","Credit";
            Caption = 'Destination Account Type';
            DataClassification = CustomerContent;
        }
        field(50031; "Error Log"; Text[250])
        {
            Caption = 'Error Log';
            DataClassification = CustomerContent;
        }
        field(50032; "Fosa Balance"; Decimal)
        {
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

    trigger OnInsert()
    begin

        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Standing Order Reg. Nos.");
           
        end;
    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
}




