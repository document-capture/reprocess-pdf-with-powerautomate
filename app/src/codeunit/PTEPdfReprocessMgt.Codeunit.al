codeunit 61130 "PTE PdfReprocess Mgt."
{
    var
        PowerAutomateWSUrlMissing: Label 'You have to configure the Microsoft Power Automate Webservice URL int the Document Capture Setup if you want to reprocess a document''s pdf file.', MaxLength = 999, Locked = false;
        WrongDocCategoryCode: Label 'The document is based a the non existing category "%1"', Comment = '%1 is replaced by the Document Category Code', MaxLength = 999, Locked = false;
        PdfNotFound: Label 'PDF File coudln''t be found', Locked = false, MaxLength = 999;
        NoPdfAttachedToDocument: Label 'There is not pdf file attached to this document %1', Comment = '%1 will be replaced by the Document No.', MaxLength = 999, Locked = false;

    procedure ReprocessDocument(Document: Record "CDC Document")
    var
        Handled: Boolean;
    begin
        OnBeforeReprocessFile(Document, Handled);
        If Handled then
            exit;

        SendDocumentToPowerAutomate(Document);
    end;

    local procedure SendDocumentToPowerAutomate(Document: Record "CDC Document")
    var
        DocCapSetup: Record "CDC Document Capture Setup";

        JsonMgt: Codeunit "JSON Management";
        Base64Convert: Codeunit "Base64 Convert";
        client: HttpClient;
        request: HttpRequestMessage;
        content: HttpContent;
        contentHeaders: HttpHeaders;
        response: HttpResponseMessage;
    begin
        if not DocCapSetup.Get() then
            exit;

        if DocCapSetup."Power Automate Webservice URL" = '' then
            Error(PowerAutomateWSUrlMissing);

        // Add the payload to the content
        content.WriteFrom(CreateJsonContent(Document));

        // Retrieve the contentHeaders associated with the content
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        request.Content := content;

        request.SetRequestUri(DocCapSetup."Power Automate Webservice URL");
        request.Method := 'POST';

        client.Send(request, response);
        Message('Response: %1', response.HttpStatusCode);
    end;

    local procedure CreateJsonContent(Document: Record "CDC Document") JsonRequestAsText: Text
    var
        object: JsonObject;
        DocCategory: Record "CDC Document Category";
    begin
        /*
        {
            "user": "BC user id",
            "tenant": "tenantid as guid",
            "pdf": "base64encoded pdf file",
            "mail": "optional base64encode msg file"
        }
        */
        if not DocCategory.Get(Document."Document Category Code") then
            Error(WrongDocCategoryCode, Document."Document Category Code");

        object.Add('user', UserId);
        object.Add('tenant', TenantId());
        object.Add('dcdocumentno', Document."No.");
        object.Add('pdf', ConvertDocumentPdfToBase64(Document));
        object.Add('mail', '');
        object.Add('ocrmailaddress', DocCategory.GetEmail());
        object.WriteTo(JsonRequestAsText);
    end;

    local procedure ConvertDocumentPdfToBase64(var Document: Record "CDC Document"): Text
    var
        TempFile: Record "CDC Temp File";
    begin
        //Get InStream of our existing logo
        if not Document.HasPdfFile() then
            error(NoPdfAttachedToDocument, Document."No.");

        if not Document.GetPdfFile(TempFile) then
            error(PdfNotFound);

        exit(TempFile.GetDataAsBase64EncodedText());
    end;



    [IntegrationEvent(true, false)]
    local procedure OnBeforeReprocessFile(var Document: Record "CDC Document"; var Handled: Boolean)
    begin
    end;

}
