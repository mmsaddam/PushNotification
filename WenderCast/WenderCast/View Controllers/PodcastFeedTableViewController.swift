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

class PodcastFeedTableViewController: UITableViewController {
  let podcastStore = PodcastStore.sharedStore

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 75

    if let patternImage = UIImage(named: "pattern-grey") {
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor(patternImage: patternImage)
      tableView.backgroundView = backgroundView
    }

    if podcastStore.items.count == 0 {
      print("Loading podcast feed for the first time")
      podcastStore.refreshItems{ didLoadNewItems in
        if (didLoadNewItems) {
          dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
          }
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PodcastFeedTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcastStore.items.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PodcastItemCell", forIndexPath: indexPath) as! PodcastItemCell

    cell.updateWithPodcastItem(podcastStore.items[indexPath.row])

    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = podcastStore.items[indexPath.row]

    if let url = NSURL(string: item.link) {
      let safari = SFSafariViewController(URL: url)
      presentViewController(safari, animated: true, completion: nil)
    }
  }
}