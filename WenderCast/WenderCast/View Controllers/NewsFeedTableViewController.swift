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
import SafariServices

class NewsFeedTableViewController: UITableViewController {
  static let RefreshNewsFeedNotification = "RefreshNewsFeedNotification"
  let newsStore = NewsStore.sharedStore

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 75

    if let patternImage = UIImage(named: "pattern-grey") {
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor(patternImage: patternImage)
      tableView.backgroundView = backgroundView
    }

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsFeedTableViewController.receivedRefreshNewsFeedNotification(_:)), name: NewsFeedTableViewController.RefreshNewsFeedNotification, object: nil)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func receivedRefreshNewsFeedNotification(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue()) {
      self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsFeedTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsStore.items.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NewsItemCell", forIndexPath: indexPath) as! NewsItemCell
    cell.updateWithNewsItem(newsStore.items[indexPath.row])
    return cell
  }

  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    let item = newsStore.items[indexPath.row]
    if let url = NSURL(string: item.link) where url.scheme == "https" {
      return true
    }
    return false
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = newsStore.items[indexPath.row]

    if let url = NSURL(string: item.link) {
      let safari = SFSafariViewController(URL: url)
      presentViewController(safari, animated: true, completion: nil)
    }
  }
}
