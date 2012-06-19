#!/usr/bin/python

import unittest
from selenium import webdriver

class EtherpadTest(unittest.TestCase):
    """This example shows how to use the page object pattern.

    For more information about this pattern, see:
    http://code.google.com/p/webdriver/wiki/PageObjects
    """

    def setUp(self):
        self.driver = webdriver.Firefox()

    def test_create_pad(self):
        driver = self.driver
        driver.get('http://localhost:9000')
        self.assertTrue("Etherpad" in driver.title)
        driver.find_element_by_id('home-newpad').click()
        #pad_contents = driver.find_element_by_id('padeditor')

    def tearDown(self):
        self.driver.close()

if __name__ == "__main__":
    unittest.main()

