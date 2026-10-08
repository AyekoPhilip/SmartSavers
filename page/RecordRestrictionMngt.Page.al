page 50486 "Record Restriction Mngt."
{
    ApplicationArea = All;
    Caption = 'Record Restriction Mngt.';
    PageType = List;
    SourceTable = "Record Restrictions Mngt.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'User ID';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Linked To Table No."; Rec."Linked To Table No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Linked To Table Name"; Rec."Linked To Table Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Restrcit Viewship (Record)"; Rec."Restrcit Viewship (Record)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Restrcit Viewship (Record) field.';
                }
                field("Restrict Viewship (ATM Card)"; Rec."Restrict Viewship (ATM Card)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Account Card) field.';
                }
                field("Restrict Viewship (Balance)"; Rec."Restrict Viewship (Balance)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Balance) field.';
                }
                field("Restrict Viewship (Mobile No.)"; Rec."Restrict Viewship (Mobile No.)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Transactional Mobile No.) field.';
                }
                field("Restrict Viewship (Statement)"; Rec."Restrict Viewship (Statement)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Restrict Viewship (Statement) field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Data Management"; Rec."Data Management")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
       DoctMngt.PermissionOnRecRestrict(UserId);
    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        ErrorOnPermissionTxt: Label 'You don not permission to Access this Page. Kindly contact your system administration for assistance';

}



