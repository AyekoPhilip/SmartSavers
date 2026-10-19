table 50327 "Record Restrictions Mngt."
{
    Caption = 'Record Restrictions Mngt.';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(50010; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
            TableRelation = Member;
        }
        field(50011; "Restrict Viewship (Balance)"; Boolean)
        {
            Caption = 'Restrict Viewship (Balance)';
            DataClassification = CustomerContent;
        }
        field(50012; "Restrict Viewship (Statement)"; Boolean)
        {
            Caption = 'Restrict Viewship (Statement)';
            DataClassification = CustomerContent;
        }
        field(50013; "Restrcit Viewship (Record)"; Boolean)
        {
            Caption = 'Restrcit Viewship (Record)';
            DataClassification = CustomerContent;
        }
        field(50014; "Restrict Viewship (ATM Card)"; Boolean)
        {
            Caption = 'Restrict Viewship (Account Card)';
            DataClassification = CustomerContent;
        }
        field(50015; "Restrict Viewship (Mobile No.)"; Boolean)
        {
            Caption = 'Restrict Viewship (Transactional Mobile No.)';
            DataClassification = CustomerContent;
        }
        field(50016; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                TestField("Document Type", "Document Type"::TableID);
            end;
        }
        field(50017; "Linked To Table No."; Integer)
        {
            Caption = 'Linked To Table No.';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = CONST(Table));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Objects.SetRange("Object Type", Objects."Object Type"::Table);
                Objects.SetRange("Object ID", "Linked To Table No.");
                if Objects.FindFirst then
                    "Linked To Table Name" := Objects."Object Name"
                else
                    "Linked To Table Name" := '';
                "Table ID" := Objects."Object ID";
            end;
        }
        field(50018; "Linked To Table Name"; Text[50])
        {
            Caption = 'Linked To Table Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Document Type"; Option)
        {
            OptionMembers = " ","Account","TableID";
            OptionCaption = ' ,Account Data,Table Data';
            DataClassification = CustomerContent;
        }
        field(50020; "Data Management"; Option)
        {
            OptionMembers = " ","Import","Export";
            OptionCaption = ' ,Import Data,Export Data';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key("PK"; "Account No.", "Linked To Table No.")
        {
            Clustered = true;
        }
    }
    var
        Objects: Record AllObjWithCaption;
}



