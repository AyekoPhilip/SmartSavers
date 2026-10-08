xmlport 50011 "Export Procurement Plan"
{
    Format = VariableText;
    Direction = Export;
    Caption = 'Export Procurement Plan';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = sorting(Number) where(Number = const(1));

                textelement(DateRef)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DateRef := 'Date';
                    end;
                }
                textelement(BranchCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BranchCode := 'Branch Code';
                    end;
                }
                textelement(DeptCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DeptCode := 'Department Code';
                    end;
                }
                textelement(ItemType)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemType := 'Item Type';
                    end;
                }
                textelement(ItemNo)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ItemNo := 'Item No.';
                    end;
                }
                textelement(Qty)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Qty := 'Quantity';
                    end;
                }
                textelement(UnitPrice)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UnitPrice := 'Unit Price';
                    end;
                }
                textelement(Justification)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Justification := 'Justification';
                    end;
                }
            }
        }
    }
}


