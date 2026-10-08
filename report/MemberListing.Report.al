report 50266 "Member Listing"
{
    ApplicationArea = All;
    Caption = 'Member Listing';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MemberListings.rdl';

    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = where("Customer Type" = filter(<> "Non-Member"));
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyTelephone; CompanyTelephone)
            {
            }
            column(CommunicationOnline; CommunicationOnline)
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(AreaServiceCenter; "Area Service Center")
            {
            }
            column(AssociatedMemberNo; "Associated Member No.")
            {
            }
            column(BankAccountNo; "Bank Account No.")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(BaseCalendarCode; "Base Calendar Code")
            {
            }
            column(BirthCertificateNo; "Birth Certificate No.")
            {
            }
            column(Blocked; Blocked)
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(BusinessGroupLocation; "Business/Group Location")
            {
            }
            column(City; City)
            {
            }
            column(Classification; Classification)
            {
            }
            column(Comment; Comment)
            {
            }
            column(CompanyRegistrationNo; "Company Registration No.")
            {
            }
            column(Contact; Contact)
            {
            }
            column(ContractType; "Contract Type")
            {
            }
            column(CountryRegion; "Country/Region")
            {
            }
            column(County; County)
            {
            }
            column(CurrentAddress; "Current Address")
            {
            }
            column(CurrentLocation; "Current Location")
            {
            }
            column(CurrentResidence; "Current Residence")
            {
            }
            column(CustomerType; "Customer Type")
            {
            }
            column(DateofBirth; "Date of Birth")
            {
            }
            column(DateofBusinessReg; "Date of Business Reg.")
            {
            }
            column(Designation; Designation)
            {
            }
            column(DividendPaymentMethod; "Dividend Payment Method")
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(EmailPersonal; "E-mail (Personal)")
            {
            }
            column(ElectrolZone; "Electrol Zone")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(EmployersPostalAddress; "Employer's Postal Address")
            {
            }
            column(EmploymentOccupationDetail; "Employment / Occupation Detail")
            {
            }
            column(FaxNo; "Fax No.")
            {
            }
            column(FileNo; "File No.")
            {
            }

            column(FirstName; "First Name")
            {
            }
            column(Gender; Gender)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }

            column(HomeAddress; "Home Address")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(Idemnity; Idemnity)
            {
            }
            column(IdentificationType; "Identification Type")
            {
            }
            column(LastDateModified; "Last Date Modified")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(LastTransactionDate; "Last Transaction Date")
            {
            }
            column(Location; Location)
            {
            }
            column(MPESAMobileNo; "MPESA Mobile No")
            {
            }
            column(MaritalStatus; "Marital Status")
            {
            }
            column(MemberCategory; "Member Category")
            {
            }
            column(MemberSegment; "Member Segment")
            {
            }
            column(MemberStation; "Member Station")
            {
            }
            column(MemberType; "Member Type")
            {
            }
            column(MembershipType; "Membership Type")
            {
            }
            column(MobilePhoneNo; "Mobile Phone No")
            {
            }
            column(Name; Name)
            {
            }
            column(Name2; "Name 2")
            {
            }
            column(Nationality; Nationality)
            {
            }

            column(No; "No.")
            {
            }

            column(OfficeTelephoneNo; "Office Telephone No.")
            {
            }
            column(OldMemberNo; "Old Member No.")
            {
            }
            column(OtherAccountType; "Other Account Type")
            {
            }
            column(OtherBusinessType; "Other Business Type")
            {
            }
            column(OtherName; "Other Name")
            {
            }
            column(OurAccountNo; "Our Account No.")
            {
            }
            column(OwnershipType; "Ownership Type")
            {
            }
            column(PINNo; "PIN No.")
            {
            }
            column(PassportNo; "Passport No.")
            {
            }
            column(PayPoint; "Pay Point")
            {
            }
            column(PayPointName; "Pay Point Name")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(Picture; Picture)
            {
            }
            column(PlotBldgStreetRoad; "Plot/Bldg/Street/Road")
            {
            }
            column(PostCode; "Post Code")
            {
            }
            column(PrimaryContactNo; "Primary Contact No.")
            {
            }
            column(PrincipalMemberNo; "Principal Member No.")
            {
            }
            column(ProtectedAccount; "Protected Account")
            {
            }
            column(RecruitedBy; "Recruited By")
            {
            }
            column(RecruitedByName; "Recruited By Name")
            {
            }
            column(RecruitedbyType; "Recruited by Type")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(Rejoined; Rejoined)
            {
            }
            column(Withdrwal_Date; "Withdrawal Date")
            { }
            column(RejoiningDate; "Rejoining Date")
            {
            }
            column(RelatestoBusinessGroup; "Relates to Business/Group")
            {
            }
            column(RelationshipManager; "Relationship Manager")
            {
            }
            column(ResonsforStatusChange; "Resons for Status Change")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(Salutation; Salutation)
            {
            }

            column(SecondName; "Second Name")
            {
            }
            column(SinglePartyMultiple; "Single Party/Multiple")
            {
            }
            column(Source; Source)
            {
            }
            column(StatementEMailFreq; "Statement E-Mail Freq.")
            {
            }
            column(StationDepartment; "Station/Department")
            {
            }
            column(Status; Status)
            {
            }
            column(TelexNo; "Telex No.")
            {
            }
            column(TerritoryCode; "Territory Code")
            {
            }
            column(Type; "Type")
            {
            }
            column(TypeofBusiness; "Type of Business")
            {
            }

            column(StaffNo; StaffNo)
            { }
            column(FosaBalanceLCY; BalanceLCY[1])
            { }
            column(DepositsBalanceLCY; BalanceLCY[2])
            { }
            column(SharesCapBalanceLCY; BalanceLCY[3])
            { }
            column(LaonsBalanceLCY; BalanceLCY[4])
            { }
            column(EmpName; EmpName)
            { }
            column(LastDepositDate; LastDepositDate)
            { }
            column(LastTransDate; LastTransDate)
            { }
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
                CommunicationOnline := 'E-mail: ' + CompanyInformation."E-Mail";// + '- Website: ' +CompanyInformation."Home Page";
                if StartDate = 0D then StartDate := 20200101D;
                if EndDate = 0D then EndDate := Today;
            end;

            trigger OnAfterGetRecord()
            begin

                BalanceLCY[1] := 0;
                BalanceLCY[2] := 0;
                BalanceLCY[3] := 0;
                BalanceLCY[4] := 0;
                LastDepositDate := 0D;
                LastTransDate := 0D;
                EmpName := '';

                BankingAcc.Reset();
                BankingAcc.SetRange("Member No.", Member."No.");
                BankingAcc.SetRange("Account Category", BankingAcc."Account Category"::Savings);
                if BankingAcc.FindFirst() then begin
                    BankingAcc.CalcFields("Balance (LCY)", "Last Transaction Date");
                    LastTransDate := BankingAcc."Last Transaction Date";
                    BalanceLCY[1] := getAccountBalance(BankingAcc."Member No.", BankingAcc."Account Category");
                    StaffNo := BankingAcc."No.";
                end;

                CredAcc.Reset();
                CredAcc.SetRange("Member No.", Member."No.");
                CredAcc.SetRange("Account Category", CredAcc."Account Category"::"Shares Deposit");
                if CredAcc.FindFirst() then begin
                    CredAcc.CalcFields("Balance (LCY)", "Last Transaction Date");
                    LastDepositDate := CredAcc."Last Transaction Date";
                    BalanceLCY[2] := getAccountBalance(CredAcc."Member No.", CredAcc."Account Category");
                end;


                CredAcc.Reset();
                CredAcc.SetRange("Member No.", Member."No.");
                CredAcc.SetRange("Account Category", CredAcc."Account Category"::"Shares Capital");
                if CredAcc.FindFirst() then begin
                    CredAcc.CalcFields("Balance (LCY)", "Last Transaction Date");
                    BalanceLCY[3] := getAccountBalance(CredAcc."Member No.", CredAcc."Account Category");
                end;


                LoansT.Reset();
                LoansT.SetRange("Account No.", Member."No.");
                if LoansT.FindSet() then begin
                    BalanceLCY[4] := getAccountBalance(LoansT."Account No.", AccType::" ");
                end;
                if Employer.get(Member."Employer Code") then begin
                    EmpName := Employer.Name;
                end;
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

        BalanceLCY: array[9] of Decimal;
        RegMngt: Codeunit "Register Management";
        SharesCapital: Decimal;
        CustAge: Integer;
        SharesDeposit: Decimal;
        TotalLoans: Decimal;
        DepMultiplier: array[5] of Decimal;
        CustEmail: Text[150];
        Employer: Record Customer;
        CustomerRec: Record Member;
        BalanceBF: Decimal;
        CName: Text[150];
        EmpName: Text;
        LastDepositDate: Date;
        AppAmount: Decimal;
        Disdate: Date;
        OutBal: Decimal;
        SavingsAccountName: Text;
        RunBalance: Decimal;
        SavingsAccountRunBal: Decimal;
        CompanyInformation: Record "Company Information";
        CompanyAddress: Text;
        CompanyTelephone: Text;
        CommunicationOnline: Text;
        LoanGuarantTotal: Decimal;
        LastTransDate: Date;

        StartDate: Date;
        EndDate: Date;
        StaffNo: Code[100];
        ProductType: Record "Product Factory";
        MembershipAge: Integer;
        BankingAcc: Record "Account Banking";
        CredAcc: Record "Account Credit";
        LoansT: Record Loans;
        AccType: Enum ProductAccountCategory;
        TellMngt: Codeunit "Teller-Post (Yes/No)";

    procedure getAccountBalance(MemberNo: Code[100]; ProdCat: Enum ProductAccountCategory) Amt: Decimal
    var

    begin
        case ProdCat of

            ProdCat::Savings:
                begin
                    BankingAcc.Reset();
                    BankingAcc.SetRange("Member No.", MemberNo);
                    BankingAcc.SetRange("Account Category", ProdCat);
                    if BankingAcc.FindFirst() then begin
                        BankingAcc.CalcFields("Balance (LCY)");
                        Amt := TellMngt.CalcAvailableBal(BankingAcc."No.");
                        StaffNo := BankingAcc."No.";
                    end;
                end;

            ProdCat::"Shares Deposit":
                begin
                    CredAcc.Reset();
                    CredAcc.SetRange("Member No.", MemberNo);
                    CredAcc.SetRange("Account Category", ProdCat);
                    if CredAcc.FindFirst() then begin
                        CredAcc.CalcFields("Balance (LCY)");
                        Amt := CredAcc."Balance (LCY)"
                    end;
                end;

            ProdCat::"Shares Capital":
                begin
                    CredAcc.Reset();
                    CredAcc.SetRange("Member No.", MemberNo);
                    CredAcc.SetRange("Account Category", ProdCat);
                    if CredAcc.FindFirst() then begin
                        CredAcc.CalcFields("Balance (LCY)");
                        Amt := CredAcc."Balance (LCY)"
                    end;
                end;

            ProdCat::" ":
                begin
                    LoansT.Reset();
                    LoansT.SetRange("Account No.", MemberNo);
                    LoansT.SetFilter("Outstanding Balance", '>0');
                    if LoansT.FindSet() then begin
                        repeat
                            LoansT.CalcFields("Outstanding Balance");
                            Amt := Amt + LoansT."Outstanding Balance";
                        until LoansT.Next() = 0;
                    end;
                end;
        end
    end;


}



