page 50016 "QC Qualifying Amount"
{
    ApplicationArea = All;
    Caption = 'QC Qualifying Amount';
    PageType = List;
    SourceTable = "QC Qualifying Amount";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type. field.';

                }
                
                field("Old Account No."; Rec."Old Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Old Account No. field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field("Qualifying Amount"; Rec."Qualifying Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qualifying Amount field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}



