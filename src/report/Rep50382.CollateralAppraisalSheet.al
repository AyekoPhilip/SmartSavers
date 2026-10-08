report 50382 "Collateral Appraisal Sheet"
{
    ApplicationArea = All;
    Caption = 'Collateral Appraisal Sheet';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CollateralAppraisalSheet.rdl';
    dataset
    {
        dataitem(CollateralRegister; "Collateral Register")
        {
            column(CompInformation; CompanyInformation.Name)
            { }
            column(CompanyInformationPicture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(Property_Holder;"Property Holder")
            {}
            column(Inward_Outward;"Inward/Outward")
            {
            }
            column(Last_Valuation_Date;"Last Valuation Date")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(ApplicationDate; "Application Date")
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
            column(CollateralType; "Collateral Type")
            {
            }
            column(CollateralValue; "Collateral Value")
            {
            }
            column(DeedTransferNo; "Deed Transfer No.")
            {
            }
            column(EngineNo; "Engine No.")
            {
            }
            column(ForcedSaleValue; "Forced Sale Value")
            {
            }
            column(IDPassport; "ID/Passport")
            {
            }
            column(InsuranceValue; "Insurance Value")
            {
            }
            column(MaturityDate; "Maturity Date")
            {
            }
            column(NextValuationDate; "Next Valuation Date")
            {
            }
            column(No; "No.")
            {
            }
            column(PINNo; "PIN No.")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(PhysicalLocation; "Physical Location")
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
            column(PropertyType; "Property Type")
            {
            }
            column(RegistrationNo; "Registration No.")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(SavingsAccountNo; "Savings Account No.")
            {
            }
            column(TermsConditions; "Terms & Conditions")
            {
            }
            column(ValueonCompletion; "Value on Completion")
            {
            }
            column(YearofManufacture; "Year of Manufacture")
            {
            }
            column(ChasisNo; "Chasis No.")
            {
            }
            column(CarModel; "Car Model")
            {
            }
            column(CarMake; "Car Make")
            {
            }
            column(CapturedBy; "Captured By")
            {
            }
            column(AnnualPremiumAmount; "Annual Premium Amount")
            {
            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' +
                CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' +
                CompanyInformation."Phone No. 2";
                //CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail" + '- Website: ' +
                //CompanyInformation."Home Page";
            end;

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPostDataItem()
            begin

            end;
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
    var
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
}
