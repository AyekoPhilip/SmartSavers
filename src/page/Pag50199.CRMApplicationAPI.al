page 50199 "CRM Application API"
{
    PageType = List;
    SourceTable = "CRM Application";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AppNo; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(AppFormNo; Rec."Application Form No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Form No. field.';
                }
                field(MemberNo; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field(ApplicType; Rec."Application Type")
                {
                    ApplicationArea = All;
                }
                field(AccName; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(ProdType; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field(PayrollNo; Rec."Payroll No.")
                {
                    ApplicationArea = All;
                }
                field(IDNo; Rec."ID No.")
                {
                    ApplicationArea = All;
                }
                field(DateOfBirth; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                }
                field(ReqAmt; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                }
                field(IdenType; Rec."Identification Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Identification Type field.';
                }
            }
        }
    }
}




