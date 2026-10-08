table 50363 "Image Data"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Picture"; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(50011; "Signature"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50012; "Member No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Old Account No."; Code[100])
        {
            Caption = 'Old Account No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Account No"; Code[100])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50015; "ID Speciment [Front]"; Media)
        {
            Caption = 'ID Speciment [Front]';
            DataClassification = CustomerContent;
        }
        field(50016; "ID Speciment [Back]"; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'ID Speciment [Back]';
        }
        field(50017; "Alien ID"; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'Alien ID';
        }
        field(50018; "Old Member No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Import Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Skip,Pending,Completed';
            OptionMembers = "Skip","Pending","Completed";
            Editable = false;
        }
        field(50020; "Picture Already Exists"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50021; "File Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50022; "File Extension"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50023; "Modified Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50024; "Modified Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(50025; "Picture ID"; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(50026; "Signature ID"; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(50027; "Description"; Text[150])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Member No.", "ID No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure CopyFromApplication(MemberApplication: Record "Member Application")
    begin

        Picture := MemberApplication.Picture;
        Signature := MemberApplication.Signature;
        "Picture ID" := MemberApplication."Picture ID";
        "Signature ID" := MemberApplication."Signature ID";
        "ID Speciment [Back]" := MemberApplication."ID Specimen [Back]";
        "ID Speciment [Front]" := MemberApplication."ID Specimen [Back]";
    end;

    procedure CopyFromChanges(MemberApplication: Record "Member Changes")
    begin

        Picture := MemberApplication.Picture;
        Signature := MemberApplication.Signature;
    end;

    procedure LoadZIPFile(ZipFileName: Text; VAR TotalCount: Integer; ReplaceMode: Boolean): Text
    begin

    end;

    procedure ImportPictures(ReplaceMode: Boolean)
    begin

    end;

    local procedure ShouldImport(ReplaceMode: Boolean; PictureExists: Boolean): Boolean
    begin

    end;

    procedure GetAddCount(): Integer
    begin

    end;

    procedure GetAddedCount(): Integer
    begin

    end;

    procedure GetReplaceCount(): Integer
    begin

    end;

    procedure GetReplacedCount(): Integer
    begin

    end;

    procedure ImportImage()
    var
        myItemRec: Record "Image Data";
        fileName: Text;
        importFile: File;
        imageInStream: InStream;
        imageID: GUID;
        Text000: Label 'An image with the following ID has been imported on item %1: %2';
    begin
        if myItemRec.FindFirst() then begin
            fileName := 'C:\images\' + Format(myItemRec."Member No.") + '.jpg';
            if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', fileName, imageInStream) then begin
                Clear(myItemRec.Picture);
                myItemRec.Picture.ImportStream(imageInStream, fileName);
                myItemRec.Modify(true)
            end;
        end;
    end;
}




