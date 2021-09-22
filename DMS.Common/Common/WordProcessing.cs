using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using DW = DocumentFormat.OpenXml.Drawing.Wordprocessing;
using PIC = DocumentFormat.OpenXml.Drawing.Pictures;
using A = DocumentFormat.OpenXml.Drawing;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using DocumentFormat.OpenXml.Vml;

namespace DMS.Common.Office
{
    public class WordProcessing : IDisposable
    {
        private WordprocessingDocument doc = null;
        public WordProcessing(string path) : this(path, true)
        {

        }

        public WordProcessing(string path, bool isEditable)
        {
            this.doc = WordprocessingDocument.Open(path, isEditable);
        }

        public void ReplaceBookmarks(List<Bookmark> list)
        {
            foreach (var item in list)
            {
                if (item.BookmarkType == BookmarkType.Text)
                {
                    this.ReplaceBookmarkToText(doc.MainDocumentPart, item.BookmarkName, item.BookmarkValue);
                }
                else if (item.BookmarkType == BookmarkType.Html)
                {
                    this.ReplaceBookmarkToHtml(doc.MainDocumentPart, item.BookmarkName, item.BookmarkValue);
                }
                else if (item.BookmarkType == BookmarkType.Image)
                {
                    this.ReplaceBookmarkToImage(doc.MainDocumentPart, item.BookmarkName, item.BookmarkValue);
                }
                if (item.BookmarkType == BookmarkType.CheckBox)
                {
                    this.ReplaceBookmarkToCheckBox(doc.MainDocumentPart, item.BookmarkName, item.BookmarkValue);
                }
                if (item.BookmarkType == BookmarkType.TextBox)
                {
                    this.ReplaceBookmarkToTextBox(doc.MainDocumentPart, item.BookmarkName, item.BookmarkValue);
                }
            }
        }

        public void ReplaceHeaderBookmarks(List<Bookmark> list)
        {
            foreach (var item in list)
            {
                if (item.BookmarkType == BookmarkType.Text)
                {
                    this.ReplaceHeaderBookmarksToText(item.BookmarkName, item.BookmarkValue);
                }
                else if (item.BookmarkType == BookmarkType.Html)
                {
                    this.ReplaceHeaderBookmarksToHtml(item.BookmarkName, item.BookmarkValue);
                }
                else if (item.BookmarkType == BookmarkType.Image)
                {
                    this.ReplaceHeaderBookmarksToImage(item.BookmarkName, item.BookmarkValue);
                }
            }
        }

        public void AppendDocuments(string[] files)
        {

            foreach (var file in files)
            {
                this.AppendDocument(file);
            }
        }

        public void test()
        {
            var txt = (from bs in doc.MainDocumentPart.RootElement.Descendants<TextInput>() where bs.Parent.ChildElements.First<FormFieldName>().Val == "Text4" select bs).FirstOrDefault();
            var bookmarkStart = (from bs in doc.MainDocumentPart.RootElement.Descendants<BookmarkStart>() where bs.Name == "Text4" select bs).FirstOrDefault();

            DefaultTextBoxFormFieldString defaultState = txt.GetFirstChild<DefaultTextBoxFormFieldString>();
            defaultState.Val = "abcdeeee";

            bool found = false;
            if (bookmarkStart != null)
            {
                OpenXmlElement nextElement = bookmarkStart.NextSibling();
                Text text = null;
                while (!found && nextElement != null)
                {
                    OpenXmlElement element = nextElement;
                    nextElement = element.NextSibling();

                    if (element is BookmarkEnd || element is BookmarkStart)
                    {
                        if (element is BookmarkEnd && ((BookmarkEnd)element).Id.Value == bookmarkStart.Id.Value)
                        {
                            found = true;
                        }
                    }
                    else
                    {
                        if (text == null)
                        {
                            text = element.Descendants<Text>().FirstOrDefault();
                        }
                    }
                }

                if (found)
                {
                    if (text != null)
                    {
                        text.Text = "abcdeeee";
                    }
                }
            }


            //var bookmarkStart = (from bs in doc.MainDocumentPart.RootElement.Descendants<BookmarkStart>() where bs.Name == "Text12" select bs).FirstOrDefault();

            //bool found = false;

            //if (bookmarkStart != null)
            //{
            //    OpenXmlElement nextElement = bookmarkStart.NextSibling();
            //    Text text = null;
            //    while (!found && nextElement != null)
            //    {
            //        OpenXmlElement element = nextElement;
            //        nextElement = element.NextSibling();

            //        if (element is BookmarkEnd || element is BookmarkStart)
            //        {
            //            if (element is BookmarkEnd && ((BookmarkEnd)element).Id.Value == bookmarkStart.Id.Value)
            //            {
            //                found = true;
            //            }
            //        }
            //        else
            //        {
            //            if (text == null)
            //            {
            //                text = element.Descendants<Text>().FirstOrDefault();
            //            }
            //            else
            //            {
            //                element.Remove();
            //            }
            //        }
            //    }

            //    if (found)
            //    {
            //        if (text != null)
            //        {
            //            text.Text = "data";
            //        }
            //        else
            //        {
            //            bookmarkStart.Parent.InsertAfter(new Run(new Text("data")), bookmarkStart);
            //        }
            //    }
            //}

            //var bookmarkStart2 = (from bs in doc.MainDocumentPart.RootElement.Descendants<BookmarkStart>() where bs.Name == "Check33" select bs).FirstOrDefault();

            //foreach (CheckBox cb in doc.MainDocumentPart.Document.Body.Descendants<CheckBox>())
            //{
            //    Console.Out.WriteLine(cb.LocalName);

            //    FormFieldName cbName = cb.Parent.ChildElements.First<FormFieldName>();
            //    Console.Out.WriteLine(cbName.Val);

            //    DefaultCheckBoxFormFieldState defaultState = cb.GetFirstChild<DefaultCheckBoxFormFieldState>();
            //    Checked state = cb.GetFirstChild<Checked>();

            //    defaultState.Val = !defaultState.Val;

            //    //Console.Out.WriteLine(defaultState.Val.ToString());

            //    //if (state.Val == null) // In case checkbox is checked the val attribute is null
            //    //{
            //    //    Console.Out.WriteLine("CHECKED");
            //    //}
            //    //else
            //    //{
            //    //    Console.Out.WriteLine(state.Val.ToString());
            //    //}
            //}
        }

        private void ReplaceBookmarkToText(OpenXmlPart xmlPart, string bookmark, string value)
        {
            //var bookmarkStart = (from bs in doc.MainDocumentPart.RootElement.Descendants<BookmarkStart>() where bs.Name == bookmark select bs).FirstOrDefault();
            var bookmarkStart = (from bs in xmlPart.RootElement.Descendants<BookmarkStart>() where bs.Name == bookmark select bs).FirstOrDefault();

            bool found = false;

            if (bookmarkStart != null)
            {
                OpenXmlElement nextElement = bookmarkStart.NextSibling();
                Text text = null;
                while (!found && nextElement != null)
                {
                    OpenXmlElement element = nextElement;
                    nextElement = element.NextSibling();

                    if (element is BookmarkEnd || element is BookmarkStart)
                    {
                        if (element is BookmarkEnd && ((BookmarkEnd)element).Id.Value == bookmarkStart.Id.Value)
                        {
                            found = true;
                        }
                    }
                    else
                    {
                        if (text == null)
                        {
                            text = element.Descendants<Text>().FirstOrDefault();
                        }
                        else
                        {
                            element.Remove();
                        }
                    }
                }

                if (found)
                {
                    if (text != null)
                    {
                        text.Text = value;
                    }
                    else
                    {
                        bookmarkStart.Parent.InsertAfter(new Run(new Text(value)), bookmarkStart);
                    }
                }
            }
        }

        private void ReplaceBookmarkToHtml(OpenXmlPart xmlPart, string bookmark, string value)
        {
            var bookmarkStart = (from bs in xmlPart.RootElement.Descendants<BookmarkStart>() where bs.Name == bookmark select bs).FirstOrDefault();

            bool found = false;

            if (bookmarkStart != null)
            {
                OpenXmlElement nextElement = bookmarkStart.NextSibling();

                while (!found && nextElement != null)
                {
                    OpenXmlElement element = nextElement;
                    nextElement = element.NextSibling();

                    if (element is BookmarkEnd || element is BookmarkStart)
                    {
                        if (element is BookmarkEnd && ((BookmarkEnd)element).Id.Value == bookmarkStart.Id.Value)
                        {
                            found = true;
                        }
                    }
                    else
                    {
                        element.Remove();
                    }
                }

                if (found)
                {
                    string altChunkId = "AltChunkId-" + Guid.NewGuid().ToString();
                    AlternativeFormatImportPart altPart = null;
                    //if (xmlPart is MainDocumentPart)
                    //{
                    //    altPart = ((MainDocumentPart)xmlPart).AddAlternativeFormatImportPart(AlternativeFormatImportPartType.Html, altChunkId);
                    //}
                    //else if (xmlPart is HeaderPart)
                    //{
                    //    altPart = ((HeaderPart)xmlPart).AddAlternativeFormatImportPart(AlternativeFormatImportPartType.Html, altChunkId);
                    //}

                    altPart = xmlPart.AddNewPart<AlternativeFormatImportPart>("text/html", altChunkId);

                    //using (MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(value)))
                    //{
                    //    altPart.FeedData(ms);
                    //}
                    //修改字体为默认字体
                    using (MemoryStream ms = new MemoryStream(Encoding.Default.GetBytes(value)))
                    {
                        altPart.FeedData(ms);
                    }


                    //添加Chunk
                    AltChunk altChunk = new AltChunk() { Id = altChunkId };

                    bookmarkStart.Ancestors<Paragraph>().First().InsertAfterSelf(altChunk);
                    //bookmarkStart.InsertAfterSelf(altChunk);
                }
            }
        }

        private void ReplaceBookmarkToImage(OpenXmlPart xmlPart, string bookmark, string value)
        {
            var bookmarkStart = (from bs in xmlPart.RootElement.Descendants<BookmarkStart>() where bs.Name == bookmark select bs).FirstOrDefault();

            bool found = false;

            if (bookmarkStart != null)
            {
                OpenXmlElement nextElement = bookmarkStart.NextSibling();

                while (!found && nextElement != null)
                {
                    OpenXmlElement element = nextElement;
                    nextElement = element.NextSibling();

                    if (element is BookmarkEnd || element is BookmarkStart)
                    {
                        if (element is BookmarkEnd && ((BookmarkEnd)element).Id.Value == bookmarkStart.Id.Value)
                        {
                            found = true;
                        }
                    }
                    else
                    {
                        element.Remove();
                    }
                }

                if (found)
                {
                    string imageId = "ImageId-" + Guid.NewGuid().ToString();
                    ImagePart imagePart = null;

                    //if (xmlPart is MainDocumentPart)
                    //{
                    //    imagePart = ((MainDocumentPart)xmlPart).AddImagePart(ImagePartType.Jpeg);
                    //    relationId = ((MainDocumentPart)xmlPart).GetIdOfPart(imagePart);
                    //}
                    //else if (xmlPart is HeaderPart)
                    //{
                    //    imagePart = ((HeaderPart)xmlPart).AddImagePart(ImagePartType.Jpeg);
                    //    relationId = ((HeaderPart)xmlPart).GetIdOfPart(imagePart);
                    //}

                    imagePart = xmlPart.AddNewPart<ImagePart>("image/jpeg", imageId);

                    using (FileStream stream = new FileStream(value, FileMode.Open))
                    {
                        imagePart.FeedData(stream);
                    }

                    bookmarkStart.InsertAfterSelf(new Run(this.CreateImage(imageId)));
                }
            }
        }

        private void ReplaceBookmarkToCheckBox(OpenXmlPart xmlPart, string bookmark, string value)
        {
            var checkBox = (from bs in xmlPart.RootElement.Descendants<CheckBox>() where bs.Parent.ChildElements.First<FormFieldName>().Val == bookmark select bs).FirstOrDefault();
            if (checkBox != null)
            {
                DefaultCheckBoxFormFieldState defaultState = checkBox.GetFirstChild<DefaultCheckBoxFormFieldState>();
                if (defaultState != null)
                {
                    defaultState.Val = bool.Parse(value);
                }
                else
                {
                    defaultState = new DefaultCheckBoxFormFieldState();
                    defaultState.Val = bool.Parse(value);
                    checkBox.AppendChild(defaultState);
                }
            }
        }

        private void ReplaceBookmarkToTextBox(OpenXmlPart xmlPart, string bookmark, string value)
        {
            var textBox = (from bs in xmlPart.RootElement.Descendants<TextInput>() where bs.Parent.ChildElements.First<FormFieldName>().Val == bookmark select bs).FirstOrDefault();
            var bookmarkStart = (from bs in xmlPart.RootElement.Descendants<BookmarkStart>() where bs.Name == bookmark select bs).FirstOrDefault();

            if (textBox != null && bookmarkStart != null)
            {
                DefaultTextBoxFormFieldString defaultState = textBox.GetFirstChild<DefaultTextBoxFormFieldString>();
                if (defaultState != null)
                {
                    defaultState.Val = value;
                }
                else
                {
                    defaultState = new DefaultTextBoxFormFieldString();
                    defaultState.Val = value;
                    textBox.AppendChild(defaultState);
                }

                bool found = false;
                if (bookmarkStart != null)
                {
                    OpenXmlElement nextElement = bookmarkStart.NextSibling();
                    Text text = null;
                    while (!found && nextElement != null)
                    {
                        OpenXmlElement element = nextElement;
                        nextElement = element.NextSibling();

                        if (element is BookmarkEnd || element is BookmarkStart)
                        {
                            if (element is BookmarkEnd && ((BookmarkEnd)element).Id.Value == bookmarkStart.Id.Value)
                            {
                                found = true;
                            }
                        }
                        else
                        {
                            if (text == null)
                            {
                                text = element.Descendants<Text>().FirstOrDefault();
                            }
                        }
                    }

                    if (found)
                    {
                        if (text != null)
                        {
                            text.Text = value;
                        }
                    }
                }
            }
        }

        private void ReplaceHeaderBookmarksToText(string bookmark, string value)
        {
            foreach (var sectPr in doc.MainDocumentPart.Document.Descendants<SectionProperties>())
            {
                foreach (var header in sectPr.Descendants<HeaderReference>())
                {
                    //Console.WriteLine(header.Id + "   " + header.Type);
                    //HeaderPart headerPart = (HeaderPart)mainPart.GetPartById(header.Id);
                    this.ReplaceBookmarkToText(doc.MainDocumentPart.GetPartById(header.Id), bookmark, value);
                }
            }
        }

        private void ReplaceHeaderBookmarksToHtml(string bookmark, string value)
        {
            foreach (var sectPr in doc.MainDocumentPart.Document.Descendants<SectionProperties>())
            {
                foreach (var header in sectPr.Descendants<HeaderReference>())
                {
                    //Console.WriteLine(header.Id + "   " + header.Type);
                    //HeaderPart headerPart = (HeaderPart)mainPart.GetPartById(header.Id);
                    this.ReplaceBookmarkToHtml(doc.MainDocumentPart.GetPartById(header.Id), bookmark, value);
                }
            }
        }

        private void ReplaceHeaderBookmarksToImage(string bookmark, string value)
        {
            foreach (var sectPr in doc.MainDocumentPart.Document.Descendants<SectionProperties>())
            {
                foreach (var header in sectPr.Descendants<HeaderReference>())
                {
                    //Console.WriteLine(header.Id + "   " + header.Type);
                    //HeaderPart headerPart = (HeaderPart)mainPart.GetPartById(header.Id);
                    this.ReplaceBookmarkToImage(doc.MainDocumentPart.GetPartById(header.Id), bookmark, value);
                }
            }
        }

        private void AppendDocument(string path)
        {
            MainDocumentPart mainPart = doc.MainDocumentPart;

            string altChunkId = "AltChunkId-" + Guid.NewGuid().ToString();
            AlternativeFormatImportPart altPart = mainPart.AddAlternativeFormatImportPart(AlternativeFormatImportPartType.WordprocessingML, altChunkId);
            using (FileStream fs = new FileStream(path, FileMode.Open))
            {
                altPart.FeedData(fs);
            }

            //添加分页符
            Paragraph paragraphPage = new Paragraph();
            Run runPage = new Run();
            Break breakPage = new Break() { Type = BreakValues.Page };
            runPage.Append(breakPage);
            paragraphPage.Append(runPage);

            //添加分节符
            Paragraph paragraphSection = new Paragraph();
            ParagraphProperties paragraphProperties = new ParagraphProperties();
            SectionProperties sectionProperties = new SectionProperties();
            SectionType sectionType = new SectionType() { Val = SectionMarkValues.NextPage };
            PageSize pageSize = new PageSize() { Width = (UInt32Value)11906U, Height = (UInt32Value)16838U };
            PageMargin pageMargin = new PageMargin() { Top = 720, Right = (UInt32Value)720U, Bottom = 720, Left = (UInt32Value)720U, Header = (UInt32Value)851U, Footer = (UInt32Value)992U, Gutter = (UInt32Value)0U };
            sectionProperties.Append(sectionType);
            sectionProperties.Append(pageSize);
            sectionProperties.Append(pageMargin);
            paragraphProperties.Append(sectionProperties);
            paragraphSection.Append(paragraphProperties);

            //添加Chunk
            AltChunk altChunk = new AltChunk() { Id = altChunkId };

            //添加到文档中
            mainPart.Document.Body.Append(paragraphPage);
            mainPart.Document.Body.Append(paragraphSection);
            mainPart.Document.Body.Append(altChunk);
        }

        private Drawing CreateImage(string relationId)
        {
            // Define the reference of the image.
            var element =
                 new Drawing(
                     new DW.Inline(
                         new DW.Extent() { Cx = 403301L, Cy = 403301L },
                         new DW.EffectExtent()
                         {
                             LeftEdge = 0L,
                             TopEdge = 0L,
                             RightEdge = 0L,
                             BottomEdge = 0L
                         },
                         new DW.DocProperties()
                         {
                             Id = (UInt32Value)1U,
                             Name = "Picture " + relationId
                         },
                         new DW.NonVisualGraphicFrameDrawingProperties(
                             new A.GraphicFrameLocks() { NoChangeAspect = true }),
                         new A.Graphic(
                             new A.GraphicData(
                                 new PIC.Picture(
                                     new PIC.NonVisualPictureProperties(
                                         new PIC.NonVisualDrawingProperties()
                                         {
                                             Id = (UInt32Value)0U,
                                             Name = "Picture " + relationId
                                         },
                                         new PIC.NonVisualPictureDrawingProperties()),
                                     new PIC.BlipFill(
                                         new A.Blip(
                                             new A.BlipExtensionList(
                                                 new A.BlipExtension()
                                                 {
                                                     Uri =
                                                        "{28A0092B-C50C-407E-A947-70E740481C1C}"
                                                 })
                                         )
                                         {
                                             Embed = relationId,
                                             CompressionState =
                                             A.BlipCompressionValues.Print
                                         },
                                         new A.Stretch(
                                             new A.FillRectangle())),
                                     new PIC.ShapeProperties(
                                         new A.Transform2D(
                                             new A.Offset() { X = 0L, Y = 0L },
                                             new A.Extents() { Cx = 403301L, Cy = 403301L }),
                                         new A.PresetGeometry(
                                             new A.AdjustValueList()
                                         )
                                         { Preset = A.ShapeTypeValues.Rectangle }))
                             )
                             { Uri = "http://schemas.openxmlformats.org/drawingml/2006/picture" })
                     )
                     {
                         DistanceFromTop = (UInt32Value)0U,
                         DistanceFromBottom = (UInt32Value)0U,
                         DistanceFromLeft = (UInt32Value)0U,
                         DistanceFromRight = (UInt32Value)0U,
                         EditId = "50D07946"
                     });

            return element;
        }

        public void Save()
        {
            this.doc.Save();
        }

        public void Close()
        {
            this.doc.Close();
        }

        public void Dispose()
        {
            this.doc.Dispose();
        }

    }

    public enum BookmarkType
    {
        Text,
        Html,
        Image,
        CheckBox,
        TextBox
    }

    public class Bookmark
    {
        public string BookmarkName { get; set; }
        public BookmarkType BookmarkType { get; set; }
        public string BookmarkValue { get; set; }
    }
}
