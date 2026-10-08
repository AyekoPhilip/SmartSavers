table 50388 "Member Documents"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Document Type"; Option)
        {
            OptionCaption = ' ,Savings,Loans';
            OptionMembers = " ","Savings","Loans";
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Document No."; Code[10])
        {
            TableRelation = "Application Document Setup";
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ApplicationDocumentSetup: Record "Application Document Setup";
            begin
                if ApplicationDocumentSetup.Get("Document No.") then begin
                    "Document Type" := ApplicationDocumentSetup."Document Type";
                    Description := ApplicationDocumentSetup.Description;
                    "Single Party/Multiple" := ApplicationDocumentSetup."Single Party/Multiple";
                end;
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
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = "Single","Multiple","Business";
            Caption = 'Single Party/Multiple';
            DataClassification = CustomerContent;
        }
        field(50014; "Reference No."; Code[20])
        {
            Editable = false;
            Caption = 'Reference No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Product ID"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Product ID';
            DataClassification = CustomerContent;
        }
        field(50016; "Product Name"; Text[100])
        {
            Editable = false;
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50017; "Provided"; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ","No","Yes";
            Caption = 'Provided';
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
}




