table 50175 "ICT Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(50010; "Incidence Nos"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Incidence Nos';
        }
        field(50011; "Registry E-Mail"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Registry E-Mail';
        }
        field(50012; "Screenshot Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Screenshot Path';
        }
        field(50013; "Security E-Mail"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Security E-Mail';
        }
        field(50014; "Escalation E-mail"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Escalation E-mail';
        }
        field(50015; "Communication Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Communication Nos';
        }
        field(50016; "Communication E-Mail"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Communication E-Mail';
        }
        field(50017; "Registry BCC"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Registry BCC';
        }
        field(50018; "Password Change Dateformula"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Last Password Change Date"; Date)
        {
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            begin
                "Next Password Change Date" := CalcDate("Password Change Dateformula", "Last Password Change Date")
            end;
        }
        field(50020; "Next Password Change Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key("Key1"; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


