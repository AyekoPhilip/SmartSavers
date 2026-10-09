table 50583 "Risk Assessment Matrix"
{
    Caption = 'Risk Assessment Matrix';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[250])
        {
            Caption = 'Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "Value"; Boolean)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Value then begin
                    if Code in ['0003', '0004', '0005'] then begin
                        "Value Integer" := 1
                    end else begin
                        "Value Integer" := 0
                    end;
                end else begin
                    "Value Integer" := 0;
                end;
            end;
        }
        field(50012; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Risk Assessment Template";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RiskTemp: Record "Risk Assessment Template";
            begin
                if RiskTemp.Get(Code) then
                    Description := RiskTemp.Description;

            end;
        }
        field(50013; "Member No."; Code[100])
        {
            TableRelation = Member;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; "Score"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50015; "Value Integer"; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Account No.", "Code")
        {
            Clustered = true;
        }
    }
}
