table 50357 "Delegate Members Applications"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52018514;
    LookupPageID = 52018514; */

    fields
    {
        field(50009; "Code"; Code[50])
        {
            Description = 'Lookup to Delegate groups';
            Editable = false;
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Delegate MNO."; Code[50])
        {
            Description = 'Lookup to Member table';
            TableRelation = Member."No.";
            Caption = 'Delegate MNO.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                Validate(Position);
                if Members.Get("Delegate MNO.") then begin
                    if (CalcDate(GeneralSetUp."Min.Delegate Membership Period", Members."Registration Date")) > Today then
                        Error(ErrMemb, GeneralSetUp."Min.Delegate Membership Period");
                    "Delegate Name" := Members.Name;
                end;
            end;
        }
        field(50011; "Delegate Name"; Text[100])
        {
            Editable = false;
            Caption = 'Delegate Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Position"; Code[50])
        {
            Description = 'Lookup 52140627 filter type tittle';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Position));
            Caption = 'Position';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                DelegateMembers.Reset;
                DelegateMembers.SetRange(Code, Code);
                DelegateMembers.SetRange(Position, Position);
                if DelegateMembers.Find('-') then begin
                    if Position <> '' then
                        Error(ErrPosition, Position);
                end;
            end;
        }
        field(50013; "Job Tittle"; Code[50])
        {
            Description = '52140627';
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
            Caption = 'Job Tittle';
            DataClassification = CustomerContent;
        }
        field(50014; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = "Open","Pending","Approved";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code", "Delegate MNO.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Members: Record Member;
        DelegateMembers: Record "Delegate Members";
        ErrPosition: Label 'You cannot have the same position of %1 within the same group';
        GeneralSetUp: Record "General Set-Up";
        ErrMemb: Label 'This member has not met minimum membership period of %1';
}




