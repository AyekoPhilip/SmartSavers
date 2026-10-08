page 50238 "Simulation Line"
{
    Caption = 'Simulation Line';
    PageType = ListPart;
    SourceTable = "Simulation Line";
    DeleteAllowed = true;
    ModifyAllowed = true;
    Editable = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("staff payroll";Rec."staff payroll")
                {
                 ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account Name. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No. field.';
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
                field("Dividend Calc. Method"; Rec."Dividend Calc. Method")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Dividend Calc. Method field.';
                }
                field("Processing Date"; Rec."Processing Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Processing Date field.';
                }
                field(Shares; Rec.Shares)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Shares field.';
                    Caption = 'Shares/Deposits';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Qualifying Shares"; Rec."Qualifying Shares")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Qualifying Shares field.';
                    Caption = 'Qualifying Amount';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Gross Dividends"; Rec."Gross Dividends")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Gross Dividends field.';
                    Caption = 'Gross Amount';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
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
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }

                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
               
            }
        }
    }
}



