tableextension 50055 "GLRegisterExt" extends "G/L Register"
{
    fields
    {
        field(50009; "Document No."; Code[50])
        {
            CalcFormula = lookup("G/L Entry"."Document No." where("Entry No." = field("From Entry No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Document No.';
        }
    }
}


