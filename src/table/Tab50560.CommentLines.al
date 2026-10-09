table 50560 "Comment Lines"
{
    Caption = 'Comment Line';
    DrillDownPageID = "Comment List";
    LookupPageID = "Comment List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'G/L Account,Customer,Vendor,Item,Resource,Job,,Resource Group,Bank Account,Campaign,Fixed Asset,Insurance,Nonstock Item,IC Partner';
            OptionMembers = "G/L Account","Customer","Vendor","Item","Resource","Job","","Resource Group","Bank Account","Campaign","Fixed Asset","Insurance","Nonstock Item","IC Partner";
            DataClassification = CustomerContent;
        }
        field(50010; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Table Name" = CONST(Customer)) Customer
            ELSE
            IF ("Table Name" = CONST(Vendor)) Vendor
            ELSE
            IF ("Table Name" = CONST(Item)) Item
            ELSE
            IF ("Table Name" = CONST(Resource)) Resource
            ELSE
            IF ("Table Name" = CONST(Job)) Job
            ELSE
            IF ("Table Name" = CONST("Resource Group")) "Resource Group"
            ELSE
            IF ("Table Name" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Table Name" = CONST(Campaign)) Campaign
            ELSE
            IF ("Table Name" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Table Name" = CONST(Insurance)) Insurance
            ELSE
            IF ("Table Name" = CONST("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
        }
        field(50011; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50014; "Comment"; Text[150])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(50015; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Created By';
        }
        field(50016; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
    }

    keys
    {
        key("Key1"; "Table Name", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Date Created" := CurrentDateTime;
        "Created By" := UserId
    end;
}




