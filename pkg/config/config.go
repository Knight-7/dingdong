package config

type Etcd struct {
	Addrs []string `json:"addrs" yaml:"etcd"`
}

type UserOptions struct {
	Name    string `json:"name" yaml:"name"`
	Version string `json:"version" yaml:"version"`
	EtcdOps Etcd   `json:"etcd" yaml:"etcd"`
}

type WebOptions struct {
	Name    string `json:"name" yaml:"name"`
	Version string `json:"version" yaml:"version"`
	EtcdOps Etcd   `json:"etcd" yaml:"etcd"`
}

type Config struct {
	UserOpts *UserOptions `json:"user" yaml:"user"`
	WebOpts  *WebOptions  `json:"web" yaml:"web"`
}
