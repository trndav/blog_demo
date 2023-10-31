#!/bin/bash
export PATH=/usr/bin:$PATH
whenever --update-crontab --set environment="development"
