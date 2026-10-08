codeunit 50033 "Document Attachment Custom"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure AddCustomTablesOnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
           
            Database::"Receipts Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

   /*  [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure AddCustomTablesOnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        ReceiptsHeader: Record "Receipts Header";
    begin
        case DocumentAttachment."Table ID" of
            Database::"Receipts Header":
                begin
                    RecRef.Open(Database::"Receipts Header");
                    if ReceiptsHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ReceiptsHeader);
                end;
        end;
    end; */

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure InsertCustomTablesOnAfterInitFieldsFromRecRef(var RecRef: RecordRef; var DocumentAttachment: Record "Document Attachment")
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            Database::"Receipts Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value();
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    procedure DownloadDocument(FilePath: Text)
    var
        FileName: Text;
    begin
        FileName := FilePath;
        //FilePath := FileMgt.OpenFileDialog('Select File', FilePath, 'All Files(*.*)|*.*');

        //FileMgt.DownloadToFile(FilePath, FileMgt.GetFileName(FilePath));
    end;

    procedure CountFiles(DocID: Code[50]; PageCaption: Text; FileNameFilter: Text): Integer
    var
        CompanyInfo: Record "Company Information";
        NameValueBuffer: Record "Name/Value Buffer";
        FileMgt: Codeunit "File Management";
        FileCounter: Integer;
        FilePath: Text;
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField(Name);
        CompanyInfo.TestField("Document Path");

        FilePath := CompanyInfo."Document Path" + '\' + CompanyInfo.Name + '\' + PageCaption + '\' + DocID;

        FileCounter := 0;
        NameValueBuffer.DeleteAll();
        FileCounter := NameValueBuffer.Count;
        exit(FileCounter);
    end;

    procedure UploadAdministrativeDocument(DocID: Code[100]; RecID: RecordId; EDMSDocType: Enum "EDMS Document Type"): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempFile: File;
        client: HttpClient;
        content: HttpContent;
        headers: HttpHeaders;
        requestMessage: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        DataInstream: InStream;
        AttachJsonObject: JsonObject;
        AllFilesDescriptionTxt: Label 'All Files (*.*)|*.*', Comment = '{Split=r''\|''}{Locked=s''1''}';
        URILink: Label 'http://192.168.88.179/erdmsApi_UN/erp_to_edrms.php';
        DataOutstream: OutStream;
        Base64Txt: Text;
        FileName: Text;
        FilePath: Text;
        jsonTxt: Text;
        responseText: Text;
        UploadFile: Text;
        DocURL: Text;
        StartPos, EndPos : Integer;
    begin
        if UploadIntoStream('Attach a document', '', AllFilesDescriptionTxt, FileName, DataInstream) then begin
            Base64Txt := Base64Convert.ToBase64(DataInstream);

            AttachJsonObject.Add('documentType', GetEDMSReferenceNumber(EDMSDocType));
            AttachJsonObject.Add('documentName', FileName);
            AttachJsonObject.Add('file', Base64Txt);

            Message(Format(AttachJsonObject));
            AttachJsonObject.WriteTo(jsonTxt);

            content.Clear();
            content.WriteFrom(jsonTxt);
            content.GetHeaders(headers);

            headers.Clear();
            headers.Add('Content-Type', 'application/json');

            requestMessage.Content := content;
            requestMessage.SetRequestUri(URILink);
            requestMessage.Method := 'POST';

            if client.Send(requestMessage, responseMessage) then begin
                responseMessage.Content.ReadAs(responseText);
                Message(responseText);
            end else
                Message('No response');

            DocURL := GetRecLinkFromMemberResponse(responseText, FileName);
            InsertRecordLink(RecID, DocURL, FileName);

            exit(FileName);
        end;
    end;

    procedure UploadMemberDocument(RecID: RecordId; EdmsDocType: Enum "EDMS Document Type"): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempFile: File;
        client: HttpClient;
        content: HttpContent;
        headers: HttpHeaders;
        requestMessage: HttpRequestMessage;
        responseMessage: HttpResponseMessage;
        DataInstream: InStream;
        AttachJsonObject: JsonObject;
        AllFilesDescriptionTxt: Label 'All Files (*.*)|*.*', Comment = '{Split=r''\|''}{Locked=s''1''}';
        URILink: Label 'http://192.168.88.179/erdmsApi_UN/erp_to_edrms_member.php';
        DataOutstream: OutStream;
        Base64Txt: Text;
        FileName: Text;
        jsonTxt: Text;
        responseText: Text;
        UploadFile, DocURL : Text;
        Member: Record Member;
    begin
        if UploadIntoStream('Attach a document', '', AllFilesDescriptionTxt, FileName, DataInstream) then begin
            Base64Txt := Base64Convert.ToBase64(DataInstream);

            GetMemberRecord(RecID, Member);

            AttachJsonObject.Add('memberNumber', Member."No.");
            AttachJsonObject.Add('customerName', Member.Name);
            AttachJsonObject.Add('fileNumber', Member."File No.");
            AttachJsonObject.Add('product', Format(EdmsDocType));
            AttachJsonObject.Add('documentName', FileName);
            AttachJsonObject.Add('file', Base64Txt);
            AttachJsonObject.WriteTo(jsonTxt);

            content.Clear();
            content.WriteFrom(jsonTxt);
            content.GetHeaders(headers);

            headers.Clear();
            headers.Add('Content-Type', 'application/json');

            requestMessage.Content := content;
            requestMessage.SetRequestUri(URILink);
            requestMessage.Method := 'POST';

            if client.Send(requestMessage, responseMessage) then
                responseMessage.Content.ReadAs(responseText)
            else
                Message('No response');

            DocURL := GetRecLinkFromMemberResponse(responseText, FileName);
            InsertRecordLink(RecID, DocURL, FileName);

            exit(FileName);
        end;
    end;

    local procedure GetEDMSReferenceNumber(DocType: Enum "EDMS Document Type"): Code[50]
    var
        EDMSClassSubject: Record "EDMS Class Subject";
    begin
        EDMSClassSubject.SetRange(Subject, DocType);
        if EDMSClassSubject.FindFirst() then
            exit(EDMSClassSubject."Reference Number");
    end;

    local procedure GetMemberRecord(RecID: RecordId; var MemberRec: Record Member)
    var
        RecRef: RecordRef;
        Members: Record Member;
        LoanApplication: Record "Loan Application";
        AddReferenceToTableErr: Label 'Please add a reference to Table %1';
    begin
        RecRef := RecID.GetRecord();

        case RecRef.Number of
            Database::Member:
                begin
                    RecRef.SetTable(Members);
                    MemberRec.Get(Members."No.");
                end;
            Database::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    MemberRec.Get(LoanApplication."Account No.");
                end;
            else begin
                Error(AddReferenceToTableErr, RecRef.Number);
            end;
        end;
    end;

    local procedure InsertRecordLink(RecID: RecordId; FileURL: Text[2048]; FileName: Text[250])
    var
        RecLink: Record "Record Link";
        LineNo: Integer;
    begin
        RecLink.LockTable();
        if RecLink.FindLast() then
            LineNo := RecLink."Link ID" + 1
        else
            LineNo := 1;

        RecLink.Init();
        RecLink."Link ID" := LineNo;
        RecLink."Record ID" := RecID;
        RecLink.URL1 := FileURL;
        RecLink.Description := FileName;
        RecLink.Type := RecLink.Type::Link;
        RecLink.Created := CurrentDateTime;
        RecLink.Company := CompanyName;
        RecLink."User ID" := UserId;
        RecLink.Insert();
    end;

    local procedure GetRecLinkFromMemberResponse(ResponseTxt: Text; FileName: Text) DocURL: Text
    var
        StartPos: Integer;
        EndPos: Integer;
        RawURL: Text;
    begin
        StartPos := StrPos(ResponseTxt, '"http');
        EndPos := StrPos(ResponseTxt, '"]]');

        RawURL := CopyStr(ResponseTxt, StartPos, (EndPos - StartPos)) + FileName + '"';
        DocURL := DelChr(RawURL, '=', '\|"');
    end;
}



