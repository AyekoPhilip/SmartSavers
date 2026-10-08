page 50025 "ICT Setup"
{
    Caption = 'ICT Setup';
    PageType = Card;
    SourceTable = "ICT Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                field("Incidence Nos"; Rec."Incidence Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incidence Nos field.';
                }
                field("Communication Nos"; Rec."Communication Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Communication Nos field.';
                }
            }
            group(Emails)
            {
                field("Communication E-Mail"; Rec."Communication E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Communication E-Mail field.';
                }
                field("Escalation E-mail"; Rec."Escalation E-mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Escalation E-mail field.';
                }
                field("Security E-Mail"; Rec."Security E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Security E-Mail field.';
                }
            }
            group(Password)
            {
                Caption = 'Password Policy';
                field("Last Password Change Date"; Rec."Last Password Change Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Password Change Date field.';
                    Visible = false;
                }
                field("Password Change Dateformula"; Rec."Password Change Dateformula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Password Change Dateformula field.';
                }
                field("Next Password Change Date"; Rec."Next Password Change Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next Password Change Date field.';
                    Editable = false;
                    Visible = false;
                }


            }
        }
    }

    trigger OnInit()
    begin
        if Rec.IsEmpty then
            Rec.Init();
    end;
}



