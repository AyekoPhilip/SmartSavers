page 50424 "Div. Simulation Lines"
{
    Caption = 'Dividend Simulation Lines';
    PageType = ListPart;
    SourceTable = "Dividend Progression";
    DeleteAllowed = true;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field("Staff/Payroll No."; Rec."Staff/Payroll No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Staff Number field.';
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Employer Code field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Shares; Rec.Shares)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Shares field.';
                    Caption = 'Shares/Deposits';

                }
                field("Qualifying Shares"; Rec."Qualifying Shares")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Qualifying Shares field.';
                    Caption = 'Qualifying Amount';
                }
                field("Gross Dividends"; Rec."Gross Dividends")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Gross Dividends field.';
                    Caption = 'Gross Amount';
                }
                field("Witholding Tax"; Rec."Witholding Tax")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Witholding Tax field.';
                }
                field("Net Dividends"; Rec."Net Dividends")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Net Dividends field.';
                }
            }
        }
    }
}



