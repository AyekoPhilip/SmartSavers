xmlport 50020 "Import Loans"
{
    Caption = 'Import Loans';
    Direction = Both;
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Loans; Loans)
            {
                fieldelement(No; Loans."No.")
                {
                }
                fieldelement(ApplicationDate; Loans."Application Date")
                {
                }
                fieldelement(ApplicationNo; Loans."Application No.")
                {
                }
                fieldelement(ProductType; Loans."Product Type")
                {
                }
                fieldelement(AccountNo; Loans."Account No.")
                {
                }
                fieldelement(RequestedAmount; Loans."Requested Amount")
                {
                }
                fieldelement(ApprovedAmount; Loans."Approved Amount")
                {
                }
                fieldelement(InterestRate; Loans."Interest Rate")
                {
                }
                fieldelement(DisbursementDate; Loans."Disbursement Date")
                {
                }
                fieldelement(Repayment; Loans.Repayment)
                {
                }
                fieldelement(InterestCalculationMethod; Loans."Interest Calculation Method")
                {
                }
                fieldelement(RepaymentStartDate; Loans."Repayment Start Date")
                {
                }
                fieldelement(DisbursementAccountNo; Loans."Disbursement Account No.")
                {
                }
                fieldelement(ExpectedDateofCompletion; Loans."Expected Date of Completion")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}



