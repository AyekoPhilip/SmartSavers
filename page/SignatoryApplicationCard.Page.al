page 50785 "Signatory Application Card"
{
    AutoSplitKey = false;
    DelayedInsert = true;
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = "Signatory Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Signatory Category"; Rec."Signatory Category")
                {
                    ApplicationArea = All;
                    Caption = 'Category';
                    trigger OnValidate()
                    begin
                        case Rec."Signatory Category" of
                            Rec."Signatory Category"::Member:
                                begin
                                    MembAccEditable := true;
                                    SigntAppEditable := false;
                                end;
                            Rec."Signatory Category"::Staff:
                                begin
                                    MembAccEditable := true;
                                    SigntAppEditable := false;
                                end;
                            Rec."Signatory Category"::"Non Member":
                                begin
                                    MembAccEditable := false;
                                    SigntAppEditable := true;
                                end;
                        end;
                    end;
                }
                field("Non Member A/c No."; Rec."Member No.")
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Names; Rec.Names)
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Second Name"; Rec."Second Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    Caption = 'ID No.';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Pin No."; Rec."Pin No.")
                {
                    ApplicationArea = All;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Occupation; Rec.Occupation)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Signatory Type';
                }
            }
            group("Comunication Details")
            {
                field("Post Code"; Rec."Post Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field(Nationality; Rec.Nationality)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
            group(Instructions)
            {
                field(Signatory; Rec.Signatory)
                {
                    ApplicationArea = All;
                }
                field("Must Sign"; Rec."Must Sign")
                {
                    ApplicationArea = All;
                }
                field("Must be Present"; Rec."Must be Present")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "Signatory App. Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Account No." = FIELD("Account No."),
                              "ID No." = FIELD("ID No.");
                ApplicationArea = All;
            }
            part(Signature; "Signatory App. Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Account No." = FIELD("Account No."), "ID No." = FIELD("ID No.");
                ApplicationArea = All;
            }
            systempart(Control13; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control12; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control14; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl;
    end;

    trigger OnOpenPage()
    begin
        UpdateControl;
    end;

    var
        SigntAppEditable: Boolean;
        MembAccEditable: Boolean;


    procedure UpdateControl()
    var
        MemberAppl: Record "Member Application";
    begin
        if MemberAppl.Get(Rec."Account No.") then begin
            case MemberAppl."Approval Status" of
                MemberAppl."Approval Status"::"Pending Approval", MemberAppl."Approval Status"::Approved, MemberAppl."Approval Status"::Rejected, MemberAppl."Approval Status"::Posted:
                    begin
                        CurrPage.Editable := false;
                    end;

                MemberAppl."Approval Status"::Open:
                    begin
                        CurrPage.Editable := true;
                    end;
            end;
        end;
    end;
}




