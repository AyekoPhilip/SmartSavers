page 50793 "Member Group"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Member;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    Caption = 'Membership Date';
                    ApplicationArea = All;
                }
                field("Single Party/Multiple/Business"; Rec."Single Party/Multiple")
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AccoutTypeControl;
                    end;
                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AccoutTypeControl;
                    end;
                }
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Relationship Manager"; Rec."Relationship Manager")
                {
                    ApplicationArea = All;
                }
                field("Recruited By"; Rec."Recruited By")
                {
                    Caption = 'Recruited By';
                    ApplicationArea = All;
                }
            }
            group(Multiple)
            {
                Visible = MultipleEdit;
                field("Group Type"; Rec."Group Type")
                {
                    ApplicationArea = All;
                }
                field("Nature of Group"; Rec."Nature of Business")
                {
                    ApplicationArea = All;
                }
                field("Group Registration No."; Rec."Company Registration No.")
                {
                    Caption = 'Group Registration No.';
                    ApplicationArea = All;
                }
                field("Date of Group Registration"; Rec."Date of Business Reg.")
                {
                    ApplicationArea = All;
                }
                field("Group Loaction"; Rec."Business/Group Location")
                {
                    ApplicationArea = All;
                }
                field("Group Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    ApplicationArea = All;
                }
            }
            group(Business)
            {
                Visible = BusinessEdit;
                field("Type of Business"; Rec."Type of Business")
                {
                    ApplicationArea = All;
                }
                field("Ownership Type"; Rec."Ownership Type")
                {
                    ApplicationArea = All;
                }
                field("Other Business Type"; Rec."Other Business Type")
                {
                    ApplicationArea = All;
                }
                field("Nature of Business"; Rec."Nature of Business")
                {
                    Caption = 'Nature of Business';
                    ApplicationArea = All;
                }
                field("Business Registration No."; Rec."Company Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Date of Business Reg."; Rec."Date of Business Reg.")
                {
                    Caption = 'Date of Business Reg.';
                    ApplicationArea = All;
                }
                field("Business Location"; Rec."Business/Group Location")
                {
                    ApplicationArea = All;
                }
                field("Business Plot/Bldg/Street/Road"; Rec."Plot/Bldg/Street/Road")
                {
                    ApplicationArea = All;
                }
            }
            group("Communication Details")
            {
                field("Office Telephone No."; Rec."Phone No.")
                {
                    Caption = 'Office Telephone No.';
                    ApplicationArea = All;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Current Address"; Rec."Current Address")
                {
                    Caption = 'P.O. BOX';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    Caption = 'City';
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
            group("Bank Details")
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Account Signatory")
            {
                Image = Relatives;
                RunObject = Page "Signatories List";
                RunPageLink = "Account No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Member Statistics")
            {
                Image = StatisticsGroup;
                RunObject = Page "Member Statistics";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Group Members")
            {
                Image = Group;
                RunObject = Page "Membership Individual List";
                RunPageLink = "Group Account No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Accounts Banking")
            {
                Image = Capacity;
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                Image = ChangeBatch;
                RunObject = Page "Account Credit List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Repayment Account")
            {
                Image = CashFlowSetup;
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(processing)
        {
            action("Dividend Instructions")
            {
                Image = InsertAccount;
                RunObject = Page "Dividend Instructions - Member";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Dividend Deduction")
            {
                Image = Database;
                RunObject = Page "Dividend Posting Buffer";
                RunPageLink = "Member No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Member File")
            {
                Image = Documents;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DMS: Record EDMS;
                begin
                    DMS.RESET;
                    DMS.SETRANGE(DMS.Key, DMS.Key::"Member File");
                    IF DMS.FIND('-') THEN BEGIN
                        HYPERLINK(DMS."url path" + Rec."No.");
                    END;
                end;
            }
            action("Allocation Details")
            {
                Caption = 'File No.';
                Image = NumberSetup;
                ApplicationArea = All;
                RunObject = page "File Allocation No.";
                RunPageLink = "ID No." = field("ID No.");

            }
            action("E-Mail Statement")
            {
                Caption = 'E-Mail Statement';
                Image = Email;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    // CustMembr := Rec;
                    // CurrPage.SETSELECTIONFILTER(CustMembr);
                    // CustMembr.EmailRecords(TRUE);
                    //
                    // CustMembr.RESET;
                    // CustMembr.SETFILTER("No.","No.");
                    // IF CustMembr.FIND('-') THEN BEGIN
                    // REPORT.RUN(52140719,TRUE,TRUE,CustMembr);
                    // END;
                end;
            }
            action("Make Changes")
            {
                Image = ManualExchangeRate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ErrorOnTxtUnpApplic: Label 'There is still open/pending application %1 that is still in the process.';
                    FieldsRef: Record "Field";
                    Rcpt: Record "Member Changes";
                    RegistryMngt: Codeunit "Registry Mngt.";
                    Response: Integer;
                begin

                    Rcpt.RESET;
                    Rcpt.SETRANGE("Member No.", Rec."No.");
                    Rcpt.SETFILTER("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
                    IF Rcpt.COUNT >= 3 THEN BEGIN
                        ERROR(ErrorOnTxtUnpApplic, Rcpt."No.");
                    END;
                    Response := ConfirmPost();
                    RegistryMngt.fnCustomerEntries(Rec, Response);
                    //FieldsRef.SetRange(TableNo, 52140542);
                    //if FieldsRef.Find('-') then begin
                    //PAGE.Run(PAGE::"Changes Setup (Field) List",
                    //FieldsRef, FieldsRef.TableNo);
                    //end   
                end;
            }
        }
        area(reporting)
        {
            action(Repayment)
            {
                Image = AbsenceCategory;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // REPORT.RUN(52140703,TRUE,FALSE,CustMembr);
                end;
            }
            action(Loans)
            {
                Image = SetupColumns;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // //REPORT.RUN(52140587,TRUE,FALSE,CustMembr);
                    // REPORT.RUN(REPORT::"Member Loans Statement",TRUE,FALSE,CustMembr);
                end;
            }
            action("Loans Detailed")
            {
                Image = ServiceOrderSetup;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // REPORT.RUN(REPORT::"Credit Loan Statement",TRUE,FALSE,CustMembr);
                end;
            }
            action(Statement)
            {
                Caption = 'Detailed Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // CustMembr.RESET;
                    // CustMembr.SETRANGE(CustMembr."No.","No.");
                    // IF CustMembr.FIND('-') THEN
                    // REPORT.RUN(52140529,TRUE,FALSE,CustMembr);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Make Changes_Promoted"; "Make Changes")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(Repayment_Promoted; Repayment)
                {
                }
                actionref(Loans_Promoted; Loans)
                {
                }
                actionref("Loans Detailed_Promoted"; "Loans Detailed")
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Dividend Instructions_Promoted"; "Dividend Instructions")
                {
                }
                actionref("Dividend Deduction_Promoted"; "Dividend Deduction")
                {
                }
                actionref("Account Signatory_Promoted"; "Account Signatory")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
                actionref("Group Members_Promoted"; "Group Members")
                {
                }
                actionref("Accounts Banking_Promoted"; "Accounts Banking")
                {
                }
                actionref("Accounts Credit_Promoted"; "Accounts Credit")
                {
                }
                actionref("Repayment Account_Promoted"; "Repayment Account")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Allocation Details_Promoted"; "Allocation Details")
                {
                }
                actionref("Member File_Promoted"; "Member File")
                {
                }
                actionref("E-Mail Statement_Promoted"; "E-Mail Statement")
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Dividends', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        AccoutTypeControl;
    end;

    trigger OnOpenPage()
    begin
        AccoutTypeControl;
    end;

    var
        MultipleEdit: Boolean;
        BusinessEdit: Boolean;


    procedure AccoutTypeControl()
    begin
        case Rec."Single Party/Multiple" of
            Rec."Single Party/Multiple"::Multiple:
                begin
                    MultipleEdit := true;
                    BusinessEdit := false;
                end;

            Rec."Single Party/Multiple"::Business:
                begin
                    BusinessEdit := true;
                    MultipleEdit := false;
                end;

        end;
    end;

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Member Details,&Image,&Account Activation,&Account Deactivation,&Block Account,&Contribution';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 6 then
            DefaultOption := 6;
        if DefaultOption <= 0 then
            DefaultOption := 1;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option on the type of change you want to initiate');
        PassInt := Selection;
        if Selection = 0 then
            exit;
        exit(PassInt);
    end;
}




