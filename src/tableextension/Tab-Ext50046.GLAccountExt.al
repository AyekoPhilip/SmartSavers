tableextension 50046 "GL_AccountExt" extends "G/L Account"
{
    fields
    {
        field(50009; "Disbursed Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("G/L Budget Entry".Amount where("G/L Account No." = field("No."),
                              "G/L Account No." = field(filter(Totaling)), "Business Unit Code" = field("Business Unit Filter"),
                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                              Date = field("Date Filter"), "Budget Name" = field("Budget Filter"), "Budget Dimension 1 Code" = field("Shortcut Dimension 3 Filter"),
                              "Budget Dimension 2 Code" = field("Shortcut Dimension 4 Filter"), "Budget Dimension 3 Code" = field("Shortcut Dimension 3 Filter"),
                              "Budget Dimension 4 Code" = field("Shortcut Dimension 6 Filter"), "Dimension Set ID" = field("Dimension Set ID Filter")));
            Caption = 'Disbursed Budget';
        }
        field(50010; "Approved Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("G/L Budget Entry".Amount where("G/L Account No." = field("No."),
                              "G/L Account No." = field(filter(Totaling)), "Business Unit Code" = field("Business Unit Filter"),
                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                              Date = field(upperlimit("Date Filter")), "Budget Name" = field("Budget Filter"), "Budget Dimension 1 Code" = field("Shortcut Dimension 3 Filter"),
                              "Budget Dimension 2 Code" = field("Shortcut Dimension 4 Filter"), "Budget Dimension 3 Code" = field("Shortcut Dimension 5 Filter"),
                              "Budget Dimension 4 Code" = field("Shortcut Dimension 6 Filter"), "Dimension Set ID" = field("Dimension Set ID Filter")));
            Caption = 'Approved Budget';
        }
        field(50011; "Shortcut Dimension 3 Filter"; Code[20])
        {
            TableRelation = "Dimension Value" where("Global Dimension No." = const(3));
            CaptionClass = '1,2,3';
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 3 Filter';
        }
        field(50012; "Shortcut Dimension 4 Filter"; Code[20])
        {
            TableRelation = "Dimension Value" where("Global Dimension No." = const(4));
            CaptionClass = '1,3,2';
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Filter';
        }
        field(50013; "Shortcut Dimension 5 Filter"; Code[20])
        {
            TableRelation = "Dimension Value" where("Global Dimension No." = const(5));
            CaptionClass = '1,3,2';
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 5 Filter';
        }
        field(50014; "Shortcut Dimension 6 Filter"; Code[20])
        {
            TableRelation = "Dimension Value" where("Global Dimension No." = const(6));
            CaptionClass = '1,3,2';
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 6 Filter';
        }
        field(50015; "Commitment"; Decimal)
        {
            Caption = 'Commitment';
        }
        field(50016; "Encumberance"; Decimal)
        {
            Caption = 'Encumberance';
        }
        field(50017; "Votebook Entry"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Votebook Entry';
        }
        field(50018; "Old Account No"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Old Account No';
        }
    }

    var
        CreateGL: Label 'Do you want to create this G/L Account in %1 Company?';

    procedure ReplicateGLAcc()
    var
        CompanyRec: Record Company;
        GLAccount: Record "G/L Account";
        GLAccount2: Record "G/L Account";
    begin
        GLAccount.Copy(Rec);

        CompanyRec.Reset();
        CompanyRec.SetFilter(Name, '<>%1', CompanyName);
        if CompanyRec.Find('-') then begin
            repeat
                GLAccount2.ChangeCompany(CompanyRec.Name);
                if not GLAccount2.Get(GLAccount."No.") then begin
                    if Confirm(CreateGL, false, CompanyRec.Name) then;
                    GLAccount2.Init();
                    GLAccount2.TransferFields(GLAccount);
                    GLAccount2.Insert();
                end;
            until CompanyRec.Next() = 0;
        end;
    end;
}


