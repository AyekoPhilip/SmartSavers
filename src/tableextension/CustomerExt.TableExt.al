tableextension 50043 "CustomerExt" extends Customer
{
    fields
    {


        field(50009; "Account Type"; Enum "CustAccountType")
        {
            Caption = 'Account Type';
        }
        field(50010; "Product Type"; Code[50])
        {
            Caption = 'Product Type';
            TableRelation = if ("Account Type" = filter("Credit Account")) "Product Factory" where("Product Class" = filter(Account)) else
            if ("Account Type" = filter("Loan Account")) "Product Factory" where("Product Class" = filter(Loan));
            Editable = false;
        }
        field(50011; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(50012; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            Editable = false;
        }
        field(50013; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            TableRelation = Member;
            Editable = false;
        }
        field(50014; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            Editable = false;
        }
        field(50015; "Account Dimension"; Enum "AccountDimension")
        {
            Caption = 'Account Dimension';
            Editable = false;
        }
        field(50016; "Net Balance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                         "Posting Date" = FIELD("Date Filter")));

            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;

        }
        field(50017; "Balance [LCY]"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }


    }
}


