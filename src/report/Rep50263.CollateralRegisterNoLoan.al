report 50263 "Collateral Register-No Loan"
{
    ApplicationArea = All;
    Caption = 'Collateral Register-No Loan';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/CollateralRegisterNoLoan.rdl';

    dataset
    {
        dataitem(CollateralRegister; "Collateral Register")
        {
            column(AccountNo; "Account No.")
            {
            }
            column(AnnualPremiumAmount; "Annual Premium Amount")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ChasisNo; "Chasis No.")
            {
            }
            column(Collateral; Collateral)
            {
            }
            column(CollateralLimit; "Collateral Limit")
            {
            }
            column(CollateralMultiplier; "Collateral Multiplier")
            {
            }
            column(CollateralName; "Collateral Name")
            {
            }
            column(CollateralPerfected; "Collateral Perfected")
            {
            }
            column(CollateralType; "Collateral Type")
            {
            }
            column(CollateralValue; "Collateral Value")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(DatePremiumLastPaid; "Date Premium Last Paid")
            {
            }
            column(EngineNo; "Engine No.")
            {
            }
            column(ForcedSaleValue; "Forced Sale Value")
            {
            }
            column(InsuranceValue; "Insurance Value")
            {
            }
            column(InwardOutward; "Inward/Outward")
            {
            }
            column(JointOwnership; "Joint Ownership")
            {
            }
            column(LastValuationDate; "Last Valuation Date")
            {
            }
            column(NextValuationDate; "Next Valuation Date")
            {
            }
            column(PINNo; "PIN No.")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(PolicyEndDate; "Policy End Date")
            {
            }
            column(PolicyNo; "Policy No.")
            {
            }
            column(PolicyStartDate; "Policy Start Date")
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PropertyType; "Property Type")
            {
            }
            column(RegistrationNo; "Registration No.")
            {
            }
            column(YearofManufacture; "Year of Manufacture")
            {
            }
            column(No; "No.")
            {
            }
            column(AccountName; "Account Name")
            {
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



