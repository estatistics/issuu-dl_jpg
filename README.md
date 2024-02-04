# issuu-dl_jpg

issuu-dl downloads documents from [issuu.com](https://issuu.com). It downloads
the document's pages in the jpg format under the title of the document.The document 
remains in numbered jpg format and it is not converted into PDF. 

## Usage

```
./issuu-dl_jpg <whole url of the magazine/book on issuu.com>
```

## Information

- It downloads the document as numbered jpg files under the title of the document and remains as such,
  it is not converted into pdf (for better quality - management).
- Title is not entirely "cleared" of html artifacts
- It will retry to download pages if internet is disconnected
- you may check wget if you need extra control options 


## Dependencies

wget, grep, sed 
