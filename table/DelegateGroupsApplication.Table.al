table 50445 "Delegate Groups Application"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52018531;
    LookupPageID = 52018531; */

    fields
    {
        field(50009; "Code"; Code[50])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Delegate Group Description"; Text[100])
        {
            Caption = 'Delegate Group Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Electoral Zone"; Code[50])
        {
            Description = 'lookup Electrol Zones/Area Svr Center (52140720) (Type=FILTER(Electral Zone))';
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = FILTER("Electral Zone"));
            Caption = 'Electoral Zone';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ElectrolZonesAreaSvrCenter.Reset;
                ElectrolZonesAreaSvrCenter.SetRange(Code, "Electoral Zone");
                ElectrolZonesAreaSvrCenter.SetRange(Type, ElectrolZonesAreaSvrCenter.Type::"Electral Zone");
                if ElectrolZonesAreaSvrCenter.Find('-') then begin
                    "Electoral Zone Name" := ElectrolZonesAreaSvrCenter.Description;
                end;
            end;
        }
        field(50012; "Electoral Zone Name"; Text[100])
        {
            Editable = false;
            Caption = 'Electoral Zone Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50014; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50015; "Created By"; Code[50])
        {
            Editable = false;
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50016; "Creation Date"; Date)
        {
            Editable = false;
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(50017; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50018; "County"; Code[50])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
            Caption = 'County';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                SegmentCountyDividendSignat.Reset;
                SegmentCountyDividendSignat.SetRange(Code, County);
                SegmentCountyDividendSignat.SetRange(Type, SegmentCountyDividendSignat.Type::County);
                if SegmentCountyDividendSignat.Find('-') then begin
                    "County Name" := SegmentCountyDividendSignat.Description;
                    ;
                end;
            end;
        }
        field(50019; "Sub-County"; Code[50])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST("Sub-County"));
            Caption = 'Sub-County';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                SegmentCountyDividendSignat.Reset;
                SegmentCountyDividendSignat.SetRange(Code, "Sub-County");
                SegmentCountyDividendSignat.SetRange(Type, SegmentCountyDividendSignat.Type::"Sub-County");
                if SegmentCountyDividendSignat.Find('-') then begin
                    "Sub-County Name" := SegmentCountyDividendSignat.Description;
                    ;
                end;
            end;
        }
        field(50020; "County Name"; Text[100])
        {
            Editable = false;
            Caption = 'County Name';
            DataClassification = CustomerContent;
        }
        field(50021; "Sub-County Name"; Text[100])
        {
            Editable = false;
            Caption = 'Sub-County Name';
            DataClassification = CustomerContent;
        }
        field(50022; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = "Open","Pending","Approved";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50023; "Created"; Boolean)
        {
            Editable = false;
            Caption = 'Created';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Code = '' then begin
            MembNoSeries.Get;
            MembNoSeries.TestField(MembNoSeries."Delegate Application Nos.");
            
            "Created By" := UserId;
            "Creation Date" := Today;
        end;
    end;

    var
        ElectrolZonesAreaSvrCenter: Record "Electrol Zones/Area Svr Center";
        MembNoSeries: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SegmentCountyDividendSignat: Record "Segment/County/Dividend/Signat";
}




