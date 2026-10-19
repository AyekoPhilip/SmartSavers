table 50074 "Budgetary Control Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(50010; "Current Budget Code"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
            DataClassification = CustomerContent;
            Caption = 'Current Budget Code';
        }
        field(50011; "Current Budget Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Budget Start Date';
        }
        field(50012; "Current Budget End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Budget End Date';
        }
        field(50013; "Budget Dimension 1 Code"; Code[20])
        {
            Caption = 'Budget Dimension 1 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                if "Budget Dimension 1 Code" <> xRec."Budget Dimension 1 Code" then begin
                  if Dim.CheckIfDimUsed("Budget Dimension 1 Code",9,Name,'',0) then
                    Error(Text000,Dim.GetCheckDimErr);
                  Modify();
                  UpdateBudgetDim("Budget Dimension 1 Code",0);
                end;
                */

            end;
        }
        field(50014; "Budget Dimension 2 Code"; Code[20])
        {
            Caption = 'Budget Dimension 2 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                if "Budget Dimension 2 Code" <> xRec."Budget Dimension 2 Code" then begin
                  if Dim.CheckIfDimUsed("Budget Dimension 2 Code",10,Name,'',0) then
                    Error(Text000,Dim.GetCheckDimErr);
                  Modify();
                  UpdateBudgetDim("Budget Dimension 2 Code",1);
                end;
                */

            end;
        }
        field(50015; "Budget Dimension 3 Code"; Code[20])
        {
            Caption = 'Budget Dimension 3 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                if "Budget Dimension 3 Code" <> xRec."Budget Dimension 3 Code" then begin
                  if Dim.CheckIfDimUsed("Budget Dimension 3 Code",11,Name,'',0) then
                    Error(Text000,Dim.GetCheckDimErr);
                  Modify();
                  UpdateBudgetDim("Budget Dimension 3 Code",2);
                end;
                */

            end;
        }
        field(50016; "Budget Dimension 4 Code"; Code[20])
        {
            Caption = 'Budget Dimension 4 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                if "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" then begin
                  if Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) then
                    Error(Text000,Dim.GetCheckDimErr);
                  Modify();
                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                end;
                */

            end;
        }
        field(50017; "Budget Dimension 5 Code"; Code[20])
        {
            Caption = 'Budget Dimension 5 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                if "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" then begin
                  if Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) then
                    Error(Text000,Dim.GetCheckDimErr);
                  Modify();
                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                end;
                */

            end;
        }
        field(50018; "Budget Dimension 6 Code"; Code[20])
        {
            Caption = 'Budget Dimension 6 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                if "Budget Dimension 4 Code" <> xRec."Budget Dimension 4 Code" then begin
                  if Dim.CheckIfDimUsed("Budget Dimension 4 Code",12,Name,'',0) then
                    Error(Text000,Dim.GetCheckDimErr);
                  Modify();
                  UpdateBudgetDim("Budget Dimension 4 Code",3);
                end;
                */

            end;
        }
        field(50019; "Analysis View Code"; Code[20])
        {
            TableRelation = "Analysis View".Code;
            DataClassification = CustomerContent;
            Caption = 'Analysis View Code';
        }
        field(50020; "Dimension 1 Code"; Code[20])
        {
            Caption = 'Dimension 1 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                TestField(Blocked,false);
                if Dim.CheckIfDimUsed("Dimension 1 Code",13,'',Code,0) then
                  Error(Text000,Dim.GetCheckDimErr);
                ModifyDim(FieldCaption("Dimension 1 Code"),"Dimension 1 Code",xRec."Dimension 1 Code");
                Modify();
                */

            end;
        }
        field(50021; "Dimension 2 Code"; Code[20])
        {
            Caption = 'Dimension 2 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                TestField(Blocked,false);
                if Dim.CheckIfDimUsed("Dimension 2 Code",14,'',Code,0) then
                  Error(Text000,Dim.GetCheckDimErr);
                ModifyDim(FieldCaption("Dimension 2 Code"),"Dimension 2 Code",xRec."Dimension 2 Code");
                Modify();
                */

            end;
        }
        field(50022; "Dimension 3 Code"; Code[20])
        {
            Caption = 'Dimension 3 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                TestField(Blocked,false);
                if Dim.CheckIfDimUsed("Dimension 3 Code",15,'',Code,0) then
                  Error(Text000,Dim.GetCheckDimErr);
                ModifyDim(FieldCaption("Dimension 3 Code"),"Dimension 3 Code",xRec."Dimension 3 Code");
                Modify();
                */

            end;
        }
        field(50023; "Dimension 4 Code"; Code[20])
        {
            Caption = 'Dimension 4 Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                TestField(Blocked,false);
                if Dim.CheckIfDimUsed("Dimension 4 Code",16,'',Code,0) then
                  Error(Text000,Dim.GetCheckDimErr);
                ModifyDim(FieldCaption("Dimension 4 Code"),"Dimension 4 Code",xRec."Dimension 4 Code");
                Modify();
                */

            end;
        }
        field(50024; "Mandatory"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mandatory';
        }
        field(50025; "Allow OverExpenditure"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow OverExpenditure';
        }
    }

    keys
    {
        key("Key1"; "Primary Key")
        {

        }
    }

    fieldgroups
    {
    }
}


