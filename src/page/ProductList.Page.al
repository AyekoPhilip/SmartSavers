page 50776 "Product List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Product Factory";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Product Class"; Rec."Product Class")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action29)
            {
                action("Product Charges")
                {
                    Image = SetupPayment;
                    RunObject = Page "Loan Product Charges";
                    RunPageLink = "Product Code" = FIELD("Product ID");
                    ApplicationArea = All;
                }
                action("Appraisal Parameters")
                {
                    Image = Evaluate;
                    ApplicationArea = All;
                }
                action("Related Product")
                {
                    Image = Relatives;
                    RunObject = Page "Related Product List";
                    RunPageLink = "Product Code" = FIELD("Product ID");
                    ApplicationArea = All;
                }
                action("Loans to Bridge")
                {
                    Image = DeleteExpiredComponents;
                    RunObject = Page "Loan Products To Bridge";
                    RunPageLink = "Product Code" = FIELD("Product ID");
                    ApplicationArea = All;
                }
                action("Interest Rates Banding")
                {
                    Image = RegisteredDocs;
                    ApplicationArea = All;
                }
            }
        }
        area(navigation)
        {
            action("Product Application Document")
            {
                Image = Documents;
                RunObject = Page "Product Document";
                RunPageLink = "Product ID" = FIELD("Product ID");
                ApplicationArea = All;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref("Related Product_Promoted"; "Related Product")
                {
                }
            }
            group(Category_Process)
            {
                actionref("Loans to Bridge_Promoted"; "Loans to Bridge")
                {
                }
                actionref("Interest Rates Banding_Promoted"; "Interest Rates Banding")
                {
                }
                actionref("Product Charges_Promoted"; "Product Charges")
                {
                }
                actionref("Appraisal Parameters_Promoted"; "Appraisal Parameters")
                {
                }
            }
            group(Category_Category4)
            {
                actionref("Product Application Document_Promoted"; "Product Application Document")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        RestrictAccess(UserId);
    end;


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            CurrPage.Editable := false;
        end;
    end;
}




