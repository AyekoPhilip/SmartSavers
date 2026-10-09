page 50433 "Banks"
{
    PageType = List;
    SourceTable = Banks;
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
                    ToolTip = 'Specifies the value of the Code field';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Branches)
            {
                Image = Warehouse;
                RunObject = page "Bank Branches";
                RunPageLink = "Bank Code" = field(Code);
                ApplicationArea = All;
                ToolTip = 'Executes the Branches action';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Branches_Promoted; Branches)
                {
                }
            }
        }
    }
}


