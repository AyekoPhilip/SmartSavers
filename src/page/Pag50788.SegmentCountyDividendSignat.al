page 50788 "Segment/County/Dividend/Signat"
{
    PageType = List;
    SourceTable = "Segment/County/Dividend/Signat";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;  
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ShowDetails;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ShowDetails;
    end;

    trigger OnOpenPage()
    begin
        ShowDetails;
    end;

    var
        CountyVisible: Boolean;


    procedure ShowDetails()
    begin
        if Rec.Type = Rec.Type::"Sub-County" then
            CountyVisible := true else
            CountyVisible := false;
    end;
}




