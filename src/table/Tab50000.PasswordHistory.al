table 50000 "Password History"
{
    Caption = 'Password History';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[100])
        {
            Caption = 'No';
            DataClassification = ToBeClassified;
        }
        field(50010; "UserName"; Code[150])
        {
            Caption = 'UserName';
            DataClassification = ToBeClassified;
        }
        field(50011; "Last Password Change"; Date)
        {
            Caption = 'Last Password Change';
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            begin
                ICTSetup.Get();
                "Next Password Change" := CalcDate(ICTSetup."Password Change Dateformula", "Last Password Change")
            end;
        }
        field(50012; "Next Password Change"; Date)
        {
            Caption = 'Next Password Change';
            DataClassification = ToBeClassified;
        }
        field(50013; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            DataClassification = ToBeClassified;
        }
        field(50014; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
    }

    keys
    {
        key("PK"; "Entry No.", "No")
        {
            Clustered = true;
        }
    }
    var
        ICTSetup: Record "ICT Setup";

}



