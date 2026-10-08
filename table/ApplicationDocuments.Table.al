table 50387 "Application Documents"
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
        
            trigger OnValidate()
            begin
                "Last Date Modified" := Today;
                "Last Modified By" := UserId;
            end;
        }
        field(50018; "Last Modified By"; Code[50])
        {
            Editable = false;
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
        }
        field(50019; "Last Date Modified"; Date)
        {
            Editable = false;
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Reference No.", "Product ID", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




