report 50395 "Top 10 Savers & Borrowers"
{
    ApplicationArea = All;
    Caption = 'Top 10 Savers & Borrowers';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout=RDLC;
    RDLCLayout= './src/report_layout/Top10Borrowers&Savers.rdl';
    
    
    
    dataset
 
    {
        dataitem(AccountBanking; "Account Credit")
        {
             
           
           
            column(CompanyInformation_Name; CompanyInformation.Name)
            { }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            { }
            column(CompanyAddress; CompanyAddress)
            { }
            column(CompanyTelephone; CompanyTelephone)
            { }
            column(CommunicationOnline; CommunicationOnline)
            { }
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(LastTransactionDate; "Last Transaction Date")
            {
            }

            column(Last_Date_Modified_Dormancy; "Last Date Modified-Dormancy")
            { }
            column(ProductName; "Product Name")
            {
            }

            column(PhoneNo; "Phone No.")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(Status; Status)
            {
            }

            column(IDPassportNo; "ID/Passport No.")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(BalanceLCY; "Balance (LCY)")
            {
            }
            column(DateofBirth; "Date of Birth")
            {
            }
            column(EMail; EmailAdress)
            {
            }

            column(StaffPayrollNo; "Staff/Payroll No.")
            {
            }
            
            dataitem(Integer;Integer )
            {
                
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(SortingCustomersCustDateFilter; StrSubstNo(Text001, CustDateFilter))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(RankedAccordingShowType; StrSubstNo(Text002, SelectStr(ShowType + 1, Text004)))
            {
            }
            column(ShowTypeNo; ShowTypeNo)
            {
            }
            column(ChartTypeNo; ChartTypeNo)
            {
            }
            
            column(CustFilter; CustFilter)
            {
            }
           
           
          
           
            column(TotalSales; TotalSales)
            {
            }
            column(TotalBalance; TotalBalance)
            {
            }
            column(CustomerTop10ListCaption; CustomerTop10ListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(TotalSalesCaption; TotalSalesCaptionLbl)
            {
            }
            column(PercentofTotalSalesCaption; PercentofTotalSalesCaptionLbl)
            {
            }
            }
            trigger OnPreDataItem()
            begin

                CompanyInformation.Get();
                CompanyInformation.CalcFields(CompanyInformation.Picture);
                CompanyAddress := CompanyInformation.Address + ' -Post Code: ' +
                CompanyInformation."Post Code" + ' -City:' +
                CompanyInformation.City + ' Region: ' + CompanyInformation."Country/Region Code";
                CompanyTelephone := 'Tel: ' + CompanyInformation."Phone No." + ' -Office Tel: ' + CompanyInformation."Phone No. 2";
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' + CompanyInformation."Home Page";

            end;

            trigger OnAfterGetRecord()
            begin
                if CustMember.Get("Member No.") then
                    EmailAdress := CustMember."E-Mail";

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
        CustMember: Record Member;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        SNo: Integer;
        EmailAdress: Code[50];

        TempCustomerAmount: Record "Customer Amount" temporary;
        Window: Dialog;
        CustFilter: Text;
        CustDateFilter: Text;
        ShowType: Option "Sales (LCY)","Balance (LCY)";
        NoOfRecordsToPrint: Integer;
        MaxAmount: Decimal;
        i: Integer;
        TotalSales: Decimal;
        TotalBalance: Decimal;
        ChartType: Option "Bar chart","Pie chart";
        ChartTypeNo: Integer;
        ShowTypeNo: Integer;
        
        ChartTypeVisible: Boolean;

        Text000: Label 'Sorting customers    #1##########';
        Text001: Label 'Period: %1';
        Text002: Label 'Ranked according to %1';
        Text004: Label 'Sales (LCY),Balance (LCY)';
        CustomerTop10ListCaptionLbl: Label 'Customer - Top 10 List';
        CurrReportPageNoCaptionLbl: Label 'Page';
        TotalCaptionLbl: Label 'Total';
        TotalSalesCaptionLbl: Label 'Total Sales';
        PercentofTotalSalesCaptionLbl: Label '% of Total Sales';
        NoOfRecordsToPrintErrMsg: Label 'The value must be a positive number.';
}



