package dao

import (
	"gorm.io/gorm"
)

type DAO struct {
	db *gorm.DB
}
