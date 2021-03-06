/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

final class NewsItem: NSObject {
  let title: String
  let date: NSDate
  let link: String

  init(title: String, date: NSDate, link: String) {
    self.title = title
    self.date = date
    self.link = link
  }
}

extension NewsItem: NSCoding {
  struct CodingKeys {
    static let Title = "title"
    static let Date = "date"
    static let Link = "link"
  }

  convenience init?(coder aDecoder: NSCoder) {
    if let title = aDecoder.decodeObjectForKey(CodingKeys.Title) as? String,
      let date = aDecoder.decodeObjectForKey(CodingKeys.Date) as? NSDate,
      let link = aDecoder.decodeObjectForKey(CodingKeys.Link) as? String {
        self.init(title: title, date: date, link: link)
    } else {
      return nil
    }
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(title, forKey: CodingKeys.Title)
    aCoder.encodeObject(date, forKey: CodingKeys.Date)
    aCoder.encodeObject(link, forKey: CodingKeys.Link)
  }
}