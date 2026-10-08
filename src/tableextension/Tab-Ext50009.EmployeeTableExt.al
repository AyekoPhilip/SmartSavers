tableextension 50009 "EmployeeTableExt" extends Employee
{
    fields
    {
        modify("Birth Date")
        {
            trigger OnAfterValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
                MinimumAgeError: Label 'Date of birth must not be less than %1';
                EmployeeRetiredErr: Label 'Employee''s age is more than allowable retirement age';
                DOBForm: DateFormula;
            begin

            end;
        }
        modify("Social Security No.")
        {
            Caption = 'NSSF No.';
        }
        modify(Status)
        {
            trigger OnAfterValidate()
            begin
                if Status = Status::Inactive then
                    Message('Kindly specify Cause For Inactivity');
            end;
        }
        field(99000; "Date of Birth - Age"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date of Birth - Age';
        }
        field(50009; "Nature of Employment"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employment Contract".Code;
            Caption = 'Nature of Employment';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Contract Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Start Date';
        
            trigger OnValidate()
            begin

                ContractPeriod := CalcDate("Contract Length", "Contract Start Date") - 1;
                "Contract End Date" := ContractPeriod;
            end;
        }
        field(50011; "Contract End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract End Date';
        }
        field(50012; "Employment Date - Age"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Employment Date - Age';
        }
        field(50013; "First Language"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'First Language';
        }
        field(50014; "Second Language"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Second Language';
        }
        field(50015; "First Language Read"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'First Language Read';
        }
        field(50016; "First Language Write"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'First Language Write';
        }
        field(50017; "First Language Speak"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'First Language Speak';
        }
        field(50018; "Second Language Read"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Second Language Read';
        }
        field(50019; "Second Language Write"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Second Language Write';
        }
        field(50020; "Second Language Speak"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Second Language Speak';
        }
        field(50021; "Other Language"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Other Language';
        }
        field(50022; "Job Position"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Position';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50023; "Job Position Title"; Text[250])
        {
            Caption = 'Job Position Title';
            Editable = false;
        }
        field(50024; "Leave Period Filter"; Code[20])
        {
            Caption = 'Leave Period Filter';
            FieldClass = FlowFilter;
        }
        field(50025; "Leave Type Filter"; Code[20])
        {
            Caption = 'Leave Type Filter';
            TableRelation = "Leave Type".Code;
            FieldClass = FlowFilter;
        }
        field(50026; "Signature"; MediaSet)
        {
            DataClassification = CustomerContent;
            Caption = 'Signature';
        }
        field(50027; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Caption = 'User ID';
        
            trigger OnValidate()
            var
                UserIDExistsErr: Label 'Employee with User ID %1 already exists';
            begin
                if "User ID" <> '' then begin
                    EmployeeRec.Reset();
                    EmployeeRec.SetRange("User ID", "User ID");
                    if EmployeeRec.FindFirst() then
                        Error(UserIDExistsErr, "User ID");
                end;
            end;
        }
        field(50028; "Disabled"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ","No","Yes";
            Caption = 'Disabled';
        }
        field(50030; "Pays NSSF?"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pays NSSF?';
        }
        field(50031; "Pays tax?"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pays tax?';
        }
        field(50032; "Basic Pay"; Decimal)
        {
            Editable = false;
            Caption = 'Total Accumulated Basic Pay';
        }
        field(50033; "Employee Nature"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Nature';
        }
        field(50034; "Position TO Succeed"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Position TO Succeed';
        }
        field(50035; "Total Allowances"; Decimal)
        {
            Editable = false;
            Caption = 'Total Accumulated Earnings';
        }
        field(50036; "Taxable Allowance"; Decimal)
        {
            Editable = false;
            Caption = 'Total Accumulated Taxable Allowance';
        }
        field(50037; "Total Deductions"; Decimal)
        {
            Editable = false;
            Caption = 'Total Accumulated Deductions';
        }
        field(50038; "Employee's Bank"; Code[80])
        {
            DataClassification = CustomerContent;
            TableRelation = Banks.Code;
            Caption = 'Employee''s Bank';
        
            trigger OnValidate()
            begin
                if Banks.Get("Employee's Bank") then
                    "Employee Bank Name" := Banks.Name;
            end;
        }
        field(50039; "Bank Branch"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Branches"."Branch Code" where("Bank Code" = field("Employee's Bank"));
            Caption = 'Bank Branch';
        
            trigger OnValidate()
            begin
                if Branches.Get("Employee's Bank", "Bank Branch") then
                    "Employee Branch Name" := Branches."Branch Name";

                "Employee Bank Sort Code" := "Employee's Bank" + "Bank Branch";
            end;
        }
        field(50040; "Bank Account Number"; Code[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account Number';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50041; "Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "Pr Employee Posting Group";
            Caption = 'Posting Group';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50042; "Salary Scale"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Grade';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50043; "Tax Deductible Amount"; Decimal)
        {
            Caption = 'Tax Deductible Amount';
        }
        field(50044; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Pay Period Filter';
        }
        field(50045; "SSF Employer to Date"; Decimal)
        {
            Caption = 'NSSF Employer to Date';
        }
        field(50046; "PIN Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PIN No.';
        }
        field(50047; "Cumm. PAYE"; Decimal)
        {
            Caption = 'Total Accumulated PAYE';
        }
        field(50048; "NHIF No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'NHIF No';
        }
        field(50049; "Benefits-Non Cash"; Decimal)
        {
            Caption = 'Benefits-Non Cash';
        }
        field(50050; "Pay Mode"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Mode';
        }
        field(50051; "Home Savings"; Decimal)
        {
            Caption = 'Home Savings';
        }
        field(50052; "Retirement Contribution"; Decimal)
        {
            Caption = 'Retirement Contribution';
        }
        field(50053; "Owner Occupier"; Decimal)
        {
            Caption = 'Owner Occupier';
        }
        field(50054; "Total Savings"; Decimal)
        {
            Caption = 'Total Savings';
        }
        field(50055; "PensionNo"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PensionNo';
        }
        field(50056; "Share Amount"; Decimal)
        {

        }
        field(50057; "Other deductions"; Decimal)
        {
            Caption = 'Other deductions';
        }
        field(50058; "Interest"; Decimal)
        {
            Caption = 'Interest';
        }
        field(50059; "Taxable Income"; Decimal)
        {
            Caption = 'Taxable Income';
        }
        field(50060; "ID No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'ID No.';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50061; "Position"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Position';
        
            trigger OnValidate()
            begin



            end;
        }
        field(50062; "Full / Part Time"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Full Time, Part Time';
            OptionMembers = "Full Time"," Part Time";
            Caption = 'Full / Part Time';
        }
        field(50063; "Contract Type"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employment Contract".Code;
            Caption = 'Contract Type';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50064; "Type of Contract"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employment Contract";
            Caption = 'Type of Contract';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50065; "Notice Period"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Notice Period';
        }
        field(50066; "Marital Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Single,Married,Separated,Divorced,Widow(er),Other';
            OptionMembers = " ","Single","Married","Separated","Divorced","Widow(er)","Other";
            Caption = 'Marital Status';
        }
        field(50067; "Ethnic Origin"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'African,Indian,White,Coloured';
            OptionMembers = "African","Indian","White","Coloured";
            Caption = 'Ethnic Origin';
        }
        field(50068; "First Language (R/W/S)"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Language;
            Caption = 'First Language (R/W/S)';
        }
        field(50069; "Driving Licence"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Driving Licence';
        }
        field(50071; "Date Of Join"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Of Join';
        
            trigger OnValidate()
            var
                JoinMonth: Integer;
                CurrentYear: Integer;
            begin



            end;
        }
        field(50072; "End Of Probation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Of Probation Date';
        }
        field(50073; "Pension Scheme Join"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Pension Scheme Join';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50074; "Medical Scheme Join"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Medical Scheme Join';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50075; "Date Of Leaving"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Of Leaving';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50076; "Second Language (R/W/S)"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Language;
            Caption = 'Second Language (R/W/S)';
        }
        field(50077; "Additional Language"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Language;
            Caption = 'Additional Language';
        }
        field(50078; "Termination Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other';
            OptionMembers = " ","Resignation","Non-Renewal Of Contract","Dismissal","Retirement","Death","Other";
            Caption = 'Termination Category';
        
            trigger OnValidate()
            var
                "Lrec Resource": Record Resource;
                OK: Boolean;
            begin
                if "Resource No." <> '' then begin
                    OK := "Lrec Resource".Get("Resource No.");
                    "Lrec Resource".Blocked := true;
                    "Lrec Resource".Modify();
                end;
            end;
        }
        field(50079; "Passport Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Passport Number';
        }
        field(50080; "HELB No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'HELB No';
        }
        field(50081; "Co-Operative No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Co-Operative No';
        }
        field(50082; "Succesion Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Succesion Date';
        }
        field(50083; "Send Alert to"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Send Alert to';
        }
        field(50084; "Religion"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Religion';
        }
        field(50085; "Served Notice Period"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Served Notice Period';
        }
        field(50086; "Exit Interview Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Exit Interview Date';
        }
        field(50087; "Exit Interview Done by"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
            Caption = 'Exit Interview Done by';
        }
        field(50088; "Allow Re-Employment In Future"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Re-Employment In Future';
        }
        field(50089; "Incremental Month"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Anniversary Month';
        }
        field(50090; "Present Pointer"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Present Step';
        
            trigger OnValidate()
            begin
                TestField("Date Of Join");

            end;
        }
        field(50091; "Previous"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Previous Step';
        }
        field(50092; "Halt"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Halt';
        }
        field(50093; "Insurance Premium"; Decimal)
        {
            Caption = 'Insurance Premium';
        }
        field(50094; "Pro-Rata Calculated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pro-Rata Calculated';
        }
        field(50095; "Basic Arrears"; Decimal)
        {
            Caption = 'Basic Arrears';
        }
        field(50096; "Relief Amount"; Decimal)
        {
            Caption = 'Relief Amount';
        }
        field(50097; "Other Language Read"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Other Language Read';
        }
        field(50098; "Other Language Write"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Other Language Write';
        }
        field(50099; "Other Language Speak"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Other Language Speak';
        }
        field(50100; "Employee Job Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = '  ,Driver,Executive,Director';
            OptionMembers = "  ","Driver","Executive","Director";
            Caption = 'Employee Job Type';
        }
        field(50101; "Contract Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Number';
        }
        field(50102; "Loan Interest"; Decimal)
        {
            Caption = 'Loan Interest';
        }
        field(50103; "Blood Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Blood Type';
        }
        field(50104; "Disability"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Disability';
        }
        field(50105; "County Code"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'County Code';
        }
        field(50106; "Retirement Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Retirement Date';
        }
        field(50107; "Medical Member No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Medical Member No';
        }
        field(50108; "Exit Ref No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Exit Ref No';
        }
        field(50109; "House Allowance"; Decimal)
        {
            Caption = 'Total Accumulated House Allowance';
        }
        field(50110; "Company"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Company;
            Caption = 'Company';
        }
        field(50111; "Min Tax Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Min Tax Rate';
        }
        field(50112; "Acting Position"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Acting Position';
        }
        field(50113; "Acting No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Acting No';
        }
        field(50114; "Acting Description"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Acting Description';
        }
        field(50115; "Relieved Employee"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Relieved Employee';
        }
        field(50116; "Relieved Name"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Relieved Name';
        }
        field(50117; "Reason for Acting"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason for Acting';
        }
        field(50118; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(50119; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }
        field(50120; "Disability Certificate"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Disability Certificate';
        }
        field(50121; "Name"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }

        field(50122; "Contract Length"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Length';
        
            trigger OnValidate()
            begin
                Validate("Contract Start Date");


            end;
        }
        field(50123; "Payroll Suspenstion Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll Suspenstion Date';
        }
        field(50124; "Payroll Reactivation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll Reactivation Date';
        }
        field(50125; "Employee Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Permanent,Partime,Locum,Casual,Contract,Board Member,Attachee,Intern';
            OptionMembers = "Permanent","Partime","Locum","Casual","Contract","Board Member","Attachee","Intern";
            Caption = 'Employee Type';
        }
        field(50126; "Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
        }

        field(50127; "Area"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Area';
        }
        field(50128; "Ethnic Community"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Ethnic Community';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50129; "Ethnic Name"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Ethnic Name';
        }
        field(50130; "Home District"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Home District';
        }
        field(50131; "Employee Bank Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Bank Name';
        }
        field(50132; "Employee Bank Sort Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Bank Sort Code';
        }
        field(50133; "Employee Branch Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Branch Name';
        }
        field(50134; "Insurance Relief"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance Relief';
        }
        field(50135; "Commuter Allowance"; Decimal)
        {
            Caption = 'Commuter Allowance';
        }
        field(50136; "Salary Arrears"; Decimal)
        {
            Caption = 'Salary Arrears';
        }
        field(50137; "Debtor Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Debtor Code';
        }
        field(50138; "Current Leave Period"; Code[20])
        {
            Caption = 'Current Leave Period';
            Editable = false;
        }
        field(50139; "Secondary Employee"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Secondary Employee';
        }
        field(50140; "Cumm. Secondary  PAYE"; Decimal)
        {
            Caption = 'Total Accumulated Sec. PAYE';
        }
        field(50141; "Leave Balance"; Decimal)
        {
            Caption = 'Leave Balance';
        }
        field(50142; "Gratuity Vendor No."; Code[50])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
            Caption = 'Gratuity Vendor No.';
        }
        field(50143; "BOSA Member No."; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Member."No.";
            Caption = 'BOSA Member No.';
        
            trigger OnValidate()
            var
                AccountsBanking: Record "Account Banking";
            begin
                if "BOSA Member No." <> '' then begin
                    AccountsBanking.Reset();
                    AccountsBanking.SetRange("Member No.", "BOSA Member No.");
                    if AccountsBanking.FindFirst() then
                        "FOSA Account No." := AccountsBanking."No.";
                end;
            end;
        }
        field(50144; "FOSA Account No."; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Account Banking"."No.";
            Caption = 'FOSA Account No.';
        }
        field(50145; "Secondary Job Position"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Secondary Job Position';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50146; "Secondary Job Position Title"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Secondary Job Position Title';
            Editable = false;
        }
        field(50147; "Responsibility Center"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
        }
        field(50148; "Leave Days Taken"; Decimal)
        {
            Caption = 'Leave Days Taken';
        }
        field(50149; "Manager/Supervisor"; Code[20])
        {
            TableRelation = Employee."No." where(Status = const(Active));
            Caption = 'Manager/Supervisor';
            DataClassification = CustomerContent;
        }
        field(50150; "Previous Salary Scale"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Previous Salary Grade';
        }
        field(50029; "Other Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50070; "Leave Entitlement"; Decimal)
        {
            Editable = false;
        }
        field(50151; "Leave Balance Brought Forward"; Decimal)
        {
            Caption = 'Leave Balance Brought Forward';
            Editable = false;
        }
        field(50152; "Leave Recall Days"; Decimal)
        {
            Caption = 'Leave Recall Days';
            Editable = false;
        }
        field(50153; "Days Absent"; Decimal)
        {
            Caption = 'Days Absent';
        }
        field(50154; "NHIF Amount"; Decimal)
        {
            Caption = 'NHIF Amount';
        }
        field(50155; "Allowances PAYE"; Decimal)
        {
            Editable = false;
        }
        field(50156; "Last Increment Date"; Date)
        {
            Caption = 'Last Increment Date';
        
            trigger OnValidate()
            begin
                if "Last Increment Date" <> 0D then
                    "Next Increment Date" := DMY2Date(1, Date2DMY("Date Of Join", 2), (Date2DMY(Today(), 3) + 1));
            end;
        }
        field(50157; "Next Increment Date"; Date)
        {
            Caption = 'Next Increment Date';
        }
        field(50158; "Gross Excludable Allowances"; Decimal)
        {
            Caption = 'Total Accumulated Earnings';
        }
        field(50159; "Last Date Increment"; Date)
        {
            Editable = false;
        }
        field(50160; "Next Date Increment"; Date)
        {
            Editable = false;
        }
        field(50161; "Leave Adjustment"; Decimal)
        {
            Editable = false;
        }
        field(50162; "Exempt from third rule"; Boolean)
        {
            Caption = 'Exempt from third rule';
        }
        field(50163; "Total Non-Recurring Allowances"; Decimal)
        {
            Caption = 'Total Non-Recurring Allowances';
        }

    }

    fieldgroups
    {
        addlast(DropDown; "Middle Name")
        {
        }
    }

    trigger OnInsert()
    begin

    end;

    var

        Branches: Record "Bank Branches";
        Banks: Record Banks;


        EmpContract: Record "Employment Contract";

        HumanResSetup: Record "Human Resources Setup";
        PayPeriod: Record "Pr Payroll Period";

        EmployeeRec: Record Employee;

        dateform: DateFormula;
        Begindate: Date;
        ContractPeriod: Date;
        Text001: Label 'Do you really want to re-assign earnings and deductions to %1 %2 ?';
        Text002: Label 'Please select the present salary pointer or assign a pointer with scale benefits defined for employee %1 %2';
        Text003: Label 'There''s no open pay period open';
        Payroll: Codeunit "Payroll Post Mngt.";
}