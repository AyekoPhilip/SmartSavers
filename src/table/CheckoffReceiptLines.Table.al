table 50456 "Checkoff Receipt Lines"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Checkoff Line Lookup Page";
    LookupPageId = "Checkoff Line Lookup Page";
    fields
    {
        field(50009; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Member No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Category" = filter("Registration Fee" | "Shares Capital" | "Shares Deposit" | "Benevolent Fund" | Insurance)) "Account Credit" else if
            ("Account Category" = filter(Savings | "Specialty Savings" | "Money Market" | "Islamic Banking")) "Account Banking" else if ("Account Category" = filter(" ")) "Credit Account";
        }
        field(50013; "Payroll/Staff No."; Code[20])
        {
            Caption = 'Payroll/Staff No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Principle Repayment" := Amount;
            end;
        }
        field(50015; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            TableRelation = Loans;
            DataClassification = CustomerContent;
        }
        field(50016; "Multiple"; Boolean)
        {
            Caption = 'Multiple';
            DataClassification = CustomerContent;
        }
        field(50017; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50018; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50020; "Type"; Option)
        {
            OptionCaption = ' ,sInterest,sLoan,sShare,wCont';
            OptionMembers = " ","SInterest","SLoan","sShare","wCont";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50021; "Product Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ProdFact.Get("Product Type") then
                    "Product Description" := ProdFact.Description
            end;
        }
        field(50022; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = CustomerContent;
        }
        field(50023; "Upload ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Upload ID';
        }
        field(50024; "Repayment Account"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Repayment Account';
            Editable = false;
            TableRelation = "Repayment Account";
        }
        field(50025; "Account Category"; Enum "ProductAccountCategory")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Category';
        
            trigger OnValidate()
            begin

                if "Member No." <> '' then begin
                    case "Account Category" of
                        "Account Category"::Other,
                            "Account Category"::"Registration Fee",
                            "Account Category"::"Shares Capital",
                            "Account Category"::"Shares Deposit",
                            "Account Category"::"Benevolent Fund",
                            "Account Category"::Insurance:
                            begin
                                CredAccount.Reset();
                                CredAccount.SetRange("Member No.", "Member No.");
                                CredAccount.SetRange("Account Category", "Account Category");
                                if CredAccount.FindFirst() then begin
                                    Validate("Product Type", CredAccount."Product Type");
                                end;

                            end;
                        "Account Category"::"Islamic Banking",
                        "Account Category"::"Specialty Savings",
                        "Account Category"::"Money Market":
                            begin
                                AccBanking.Reset();
                                AccBanking.SetRange("Member No.", "Member No.");
                                AccBanking.SetRange("Account Category", AccBanking."Account Category");
                                if AccBanking.FindFirst() then begin
                                    Validate("Product Type", AccBanking."Product Type");
                                end;

                            end;
                        "Account Category"::" ":
                            begin

                            end;
                    end;
                end;
            end;
        }
        field(50026; "Upload Response"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Upload Response';
        }
        field(50027; "Account Found"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Found';
        }
        field(50028; "Employer Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Employer Code';
        }
        field(50029; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50030; "Status"; Enum "MemberStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }
        field(50031; "Blocked"; Enum "Customer Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50032; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50033; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50034; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50035; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Created By';
        }
        field(50036; "Poated By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Poated By';
        }
        field(50037; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50038; "Line Validated"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Line Validated';
        }
        field(50039; "Banking Account Not Found"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Found Not (Banking)';
        }
        field(50040; "Credit Account Not Found"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Not Found (Credit)';
        }
        field(50041; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }
        field(50042; "Product Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                Description := UpperCase(Description)
            end;
        }
        field(50043; "Transaction Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50044; "Principle Repayment"; Decimal)
        {
            Editable = false;
            Caption = 'Principle Repayment';
            DataClassification = CustomerContent;
        }
        field(50045; "Interest Repayment"; Decimal)
        {
            Editable = false;
            Caption = 'Interest Repayment';
            DataClassification = CustomerContent;
        }
        field(50046; "Outstanding Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key("Key1"; "Entry No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PassDocumentNo
    end;

    var
        Temp: Record "User Setup";

    local procedure PassDocumentNo()
    begin
        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        "Global Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Global Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Created By" := UserId
    end;


    procedure fncheckRequiredItems()
    begin
        TestField(Amount);
        TestField("Upload ID");
        TestField("Upload Response");
    end;

    var
        CustRecord: Record Member;
        RepayAcc: Record "Repayment Account";
        CredAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
        Loans: Record Loans;
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        SavingsAcc: Record "Account Banking";
        CreditAcc: Record "Credit Account";
        CreditRepayAcc: Record "Repayment Account";
        ProdFact: Record "Product Factory";
}




