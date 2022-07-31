variable "mongo_uri" {
  sensitive = true
}

variable "ipfs_host" {

}

variable "bitcoin_host" {

}

variable "bitcoin_user" {
  sensitive = true
}

variable "bitcoin_password" {
  sensitive = true
}

variable "bitcoin_wallet" {
  sensitive = true
  default   = "0e78a499288aaa3a19e6bc2af5230e7dbe6e5239acda98ceab06acfa5a38272c" # Random empty wallet
}

