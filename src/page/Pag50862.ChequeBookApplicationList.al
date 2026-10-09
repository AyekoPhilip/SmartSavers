page 50862 "Cheque Book Application List"
{
    CardPageID = "Cheque Application";
    DeleteAllowed = false;
    Editable = true;
    PageType = List;
    SourceTable = "Cheque Book Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Account No."; Rec."Cheque Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Staff No."; Rec."Staff No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Application Exported"; Rec."Application Exported")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Export Applications")
            {
                Image = Export;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ChqAppl.Reset;
                    ChqAppl.SetRange(ChqAppl."Application Exported", false);
                    ChqAppl.SetRange(Select, true);
                    XMLPORT.Run(52140651, true, false, ChqAppl);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Export Applications_Promoted"; "Export Applications")
                {
                }
            }
        }
    }

    var
        ChqAppl: Record "Cheque Book Application";
}




