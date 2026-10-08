page 50833 "Loan Application Posted"
{
    CardPageID = "Loans Posted";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Application";
    SourceTableView = WHERE("Application Type" = CONST(Normal),
                            "Approval Status" = FILTER(Posted));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Appraisal Parameter")
            {
                Image = StepOver;
                Visible = true;
                Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                ApplicationArea = All;
                RunObject = page "Loan Appraisal Parameter";
                RunPageLink = "No." = field("No."),
                                      "Account No." = field("Account No.");
                                      
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Appraisal Parameter_Promoted"; "Appraisal Parameter")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := ObjEmp.Name;
    end;

    var
        ObjEmp: Record Customer;
        ObjName: Text[150];
}




