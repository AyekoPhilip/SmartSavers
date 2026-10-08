report 50325 "Next of Kin Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/NextofKinDetails.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Next of KIN"; "Next of KIN")
        {
            RequestFilterFields = "Account No", Type;
            column(EntryNo_NextofKIN; "Next of KIN"."Entry No.")
            {
            }
            column(AccountNo_NextofKIN; "Next of KIN"."Account No")
            {
            }
            column(Name_NextofKIN; "Next of KIN".Name)
            {
            }
            column(Relationship_NextofKIN; "Next of KIN".Relationship)
            {
            }
            column(Beneficiary_NextofKIN; "Next of KIN".Beneficiary)
            {
            }
            column(DateofBirth_NextofKIN; "Next of KIN"."Date of Birth")
            {
            }
            column(Address_NextofKIN; "Next of KIN".Address)
            {
            }
            column(Telephone_NextofKIN; "Next of KIN".Telephone)
            {
            }
            column(Fax_NextofKIN; "Next of KIN".Fax)
            {
            }
            column(Email_NextofKIN; "Next of KIN".Email)
            {
            }
            column(IDNo_NextofKIN; "Next of KIN"."ID No.")
            {
            }
            column(Allocation_NextofKIN; "Next of KIN".Allocation)
            {
            }
            column(Type_NextofKIN; "Next of KIN".Type)
            {
            }
            column(Deceased_NextofKIN; "Next of KIN".Deceased)
            {
            }
            column(BBFEntitlementCode_NextofKIN; "Next of KIN"."BBF Entitlement Code")
            {
            }
            column(BBFEntitlement_NextofKIN; "Next of KIN"."BBF Entitlement")
            {
            }
            column(AccountCategory_NextofKIN; "Next of KIN"."Specify If Others")
            {
            }
            column(OldMemberNo_NextofKIN; "Next of KIN"."Application No.")
            {
            }
            column(OldAccountNo_NextofKIN; "Next of KIN"."Post Code")
            {
            }
            column(Specify_NextofKIN; "Next of KIN"."Kin Type")
            {
            }
            column(CustName; CustName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CustM.Reset;
                CustM.SetRange("No.", "Next of KIN"."Account No");
                if CustM.Find('-') then
                    CustName := CustM.Name else
                    CustName := '';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CustM: Record Member;
        CustName: Text[250];
}




